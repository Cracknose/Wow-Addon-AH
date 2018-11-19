1 >---------------------------------------
function scan()
	get_state().query_index = get_state().query_index and get_state().query_index + 1 or 1
	if get_query() and not get_state().stopped then
		do (get_state().params.on_start_query or pass)(get_state().query_index) end
		if get_query().blizzard_query then
			if (get_query().blizzard_query.first_page or 0) <= (get_query().blizzard_query.last_page or aux.huge) then
				get_state().page = get_query().blizzard_query.first_page or 0
				return submit_query()
			end
		else
			get_state().page = nil
			return scan_page()
		end
	end
	return complete()
end

do
	local function submit()
			get_state().last_list_query = GetTime()
			local blizzard_query = get_query().blizzard_query or T.acquire()
			QueryAuctionItems(
				blizzard_query.name,
				blizzard_query.min_level,
				blizzard_query.max_level,
				blizzard_query.slot,
				blizzard_query.class,
				blizzard_query.subclass,
				get_state().page,
				blizzard_query.usable,
				blizzard_query.quality
			)
		end
		return wait_for_results()
	end
	function submit_query()
		if get_state().stopped then return end
		if get_state().params.type ~= 'list' then
			return submit()
		else
			return aux.when(CanSendAuctionQuery, submit)
		end
	end
end

2>--------------------

function wait_for_results()
    if get_state().params.type == 'list' then
        return wait_for_list_results()
    end
end

3>--------------------

function wait_for_list_results()
    local updated, last_update
    local listener_id = aux.event_listener('AUCTION_ITEM_LIST_UPDATE', function()
        last_update = GetTime()
        updated = true
    end)
    local timeout = aux.later(5, get_state().last_list_query)
    local ignore_owner = get_state().params.ignore_owner or aux_ignore_owner
	return aux.when(function()
		if not last_update and timeout() then
			return true
		end
		if last_update and GetTime() - last_update > 5 then
			return true
		end
		-- short circuiting order important, owner_data_complete must be called iif an update has happened.
		if updated and (ignore_owner or owner_data_complete()) then
			return true
		end
		updated = false
	end, function()
		aux.kill_listener(listener_id)
		if not last_update and timeout() then
			return submit_query()
		else
			return accept_results()
		end
	end)
end


4>------------------------

function accept_results()
	_,  get_state().total_auctions = GetNumAuctionItems(get_state().params.type)
	do
		(get_state().params.on_page_loaded or pass)(
			get_state().page - (get_query().blizzard_query.first_page or 0) + 1,
			last_page(get_state().total_auctions) - (get_query().blizzard_query.first_page or 0) + 1,
			total_pages(get_state().total_auctions) - 1
		)
	end
	return scan_page()
end


5>---------------------------

function scan_page(i)
	i = i or 1

	if i > PAGE_SIZE then		-- PAGE_SIZE är 50
		do (get_state().params.on_page_scanned or pass)() end
		if get_query().blizzard_query and get_state().page < last_page(get_state().total_auctions) then
			get_state().page = get_state().page + 1
			return submit_query()
		else
			return scan()
		end
	end

	local auction_info = info.auction(i, get_state().params.type)
	if auction_info and (auction_info.owner or get_state().params.ignore_owner or aux_ignore_owner) then
		auction_info.index = i
		auction_info.page = get_state().page
		auction_info.blizzard_query = get_query().blizzard_query
		auction_info.query_type = get_state().params.type

		history.process_auction(auction_info)

		if (get_state().params.auto_buy_validator or pass)(auction_info) then
			local send_signal, signal_received = aux.signal()
			aux.when(signal_received, scan_page, i)
			return aux.place_bid(auction_info.query_type, auction_info.index, auction_info.buyout_price, send_signal)
		elseif not get_query().validator or get_query().validator(auction_info) then
			do (get_state().params.on_auction or pass)(auction_info) end
		end
	end

	return scan_page(i + 1)
end


6>-----------------------------
function M.auction(index, query_type)
    query_type = query_type or 'list'

    local link = GetAuctionItemLink(query_type, index)
	if link then
        local item_id, suffix_id, unique_id, enchant_id = parse_link(link)
        local item_info = T.temp-item(item_id, suffix_id, unique_id, enchant_id)

        local name, texture, count, quality, usable, level, start_price, min_increment, buyout_price, high_bid, high_bidder, owner, sale_status = GetAuctionItemInfo(query_type, index)

    	local duration = GetAuctionItemTimeLeft(query_type, index)
        local tooltip, tooltip_money = tooltip('auction', query_type, index)
        local max_charges = max_item_charges(item_id)
        local charges = max_charges and item_charges(tooltip)
        local aux_quantity = charges or count
        local blizzard_bid = high_bid > 0 and high_bid or start_price
        local bid_price = high_bid > 0 and (high_bid + min_increment) or start_price

        return T.map(
            'item_id', item_id,
            'suffix_id', suffix_id,
            'unique_id', unique_id,
            'enchant_id', enchant_id,

            'link', link,
            'itemstring', item_info.itemstring,
            'item_key', item_id .. ':' .. suffix_id,
            'search_signature', aux.join(T.temp-T.list(item_id, suffix_id, enchant_id, start_price, buyout_price, bid_price, aux_quantity, duration, query_type == 'owner' and high_bidder or (high_bidder and 1 or 0), aux_ignore_owner and (is_player(owner) and 0 or 1) or (owner or '?')), ':'),
            'sniping_signature', aux.join(T.temp-T.list(item_id, suffix_id, enchant_id, start_price, buyout_price, aux_quantity, aux_ignore_owner and (is_player(owner) and 0 or 1) or (owner or '?')), ':'),

            'name', name,
            'texture', texture,
            'level', item_info.level,
            'type', item_info.type,
            'subtype', item_info.subtype,
            'slot', item_info.slot,
            'quality', quality,
            'max_stack', item_info.max_stack,

            'count', count,
            'start_price', start_price,
            'high_bid', high_bid,
            'min_increment', min_increment,
            'blizzard_bid', blizzard_bid,
            'bid_price', bid_price,
            'buyout_price', buyout_price,
            'unit_blizzard_bid', blizzard_bid / aux_quantity,
            'unit_bid_price', bid_price / aux_quantity,
            'unit_buyout_price', buyout_price / aux_quantity,
            'high_bidder', high_bidder,
            'owner', owner,
            'sale_status', sale_status,
            'duration', duration,
            'usable', usable,

            'tooltip', tooltip,
    	    'tooltip_money', tooltip_money,
            'max_charges', max_charges,
            'charges', charges,
            'aux_quantity', aux_quantity
        )
    end
end