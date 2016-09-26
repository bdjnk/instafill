local fill_mode = false
local fpos = {} -- first (node's) position
local pname = "" -- previous (node type's) name

local inv = nil -- placer:get_inventory()
local creative_mode = minetest.setting_getbool("creative_mode")

local fill = function (pos, placer, itemstack)
	local ppos = {} -- previous position

	local x1 = math.min(fpos.x, pos.x) -- smaller x
	local x2 = math.max(fpos.x, pos.x) -- larger x

	local y1 = math.min(fpos.y, pos.y)
	local y2 = math.max(fpos.y, pos.y)

	local z1 = math.min(fpos.z, pos.z)
	local z2 = math.max(fpos.z, pos.z)

	for nx = x1, x2 do
		for ny = y1, y2 do
			for nz = z1, z2 do
				local npos = {x=nx, y=ny, z=nz} -- next position

				-- remove the 'cname' lines for hungery mode (replaces all node types)
				local cname = minetest.get_node(npos).name
				if cname == "air" or cname == "default:water" then -- skips both corners

					if creative_mode then
						minetest.add_node(npos, {name = pname})

					-- replace the if else below with "add_node" for free filler nodes
					elseif not itemstack:is_empty() then
						itemstack:take_item(1)
						minetest.add_node(npos, {name = pname})

					else -- itemstack:is_empty()
						placer:set_wielded_item(itemstack) -- update the inventory (remove empty stack)

						if inv:contains_item("main", pname) then
							itemstack:replace(inv:remove_item("main", {name=pname, count=itemstack:get_stack_max()}))
							placer:set_wielded_item(itemstack) -- update the inventory (grab next stack)

							if not itemstack:is_empty() then
								itemstack:take_item(1)
								minetest.add_node(npos, {name = pname})
							end

						else
							minetest.remove_node(ppos)
							return itemstack -- all out of blocks to place
						end
					end
					ppos = npos
				end
			end
		end
	end
	return itemstack -- all done building the cuboid
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if not fill_mode then return end -- make sure box mode is on

	-- new node type or fpos is empty (set by 'fpos = {}')
	if fpos.x == nil or pname ~= newnode.name then
		fpos = pos
		pname = newnode.name
		minetest.chat_send_player(placer:get_player_name(), "Place a second corner to fill the cuboid");
	else
		inv = placer:get_inventory()
		itemstack = fill(pos, placer, itemstack) -- fill the cuboid
		placer:set_wielded_item(itemstack) -- update the inventory (remove used blocks)
		
		-- exit fill mode on any placement (safe)
		fpos = {}
		fill_mode = false;
		minetest.chat_send_player(placer:get_player_name(), "You are no longer in fill mode");

		--fpos = {} -- wait for a new first corner (dangerous)
		--fpos = pos -- make the second corner the next cuboid's first corner (very dangerous)
	end
end
)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not fill_mode then return end

	-- exit fill mode on any dig (safe)
	fpos = {}
	fill_mode = false;
	minetest.chat_send_player(digger:get_player_name(), "You are no longer in fill mode");
	
	-- allow digging while in fill mode (dangerous)
	--[[
	if fpos.x == pos.x and fpos.y == pos.y and fpos.z == pos.z then
		fpos = {} -- when we dig a node, remove it from instafill
		minetest.chat_send_player(digger:get_player_name(), "First corner removed, fill mode reset");
	end
	]]
end
)

minetest.register_chatcommand("f", {
	params = "",
	description = "fill: fill mode switch",
	func = function(name, param)
		fill_mode = not fill_mode
		fpos = {}
		minetest.chat_send_player(name, "You are "..(fill_mode and "now" or "no longer").." in fill mode");
	end,
})
