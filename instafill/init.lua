local boxmode = false
local fpos = {} -- first (node's) position
local pname = "" -- previous (node type's) name

local inv = nil -- placer:get_inventory()

build_box = function (pos, placer, itemstack)
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
				local cname = minetest.env:get_node(npos).name
				if cname == "air" or cname == "default:water" then -- skips both corners

					-- replace the if else below with "add_node" for free filler nodes
					if not itemstack:is_empty() then
						itemstack:take_item(1)
						minetest.env:add_node(npos, {name = pname})

					else -- itemstack:is_empty()
						placer:set_wielded_item(itemstack) -- update the inventory (remove empty stack)

						if inv:contains_item("main", pname) then
							itemstack:replace(inv:remove_item("main", {name=pname, count=itemstack:get_stack_max()}))
							placer:set_wielded_item(itemstack) -- update the inventory (grab next stack)

							if not itemstack:is_empty() then
								itemstack:take_item(1)
								minetest.env:add_node(npos, {name = pname})
							end

						else
							minetest.env:remove_node(ppos)
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
	if not boxmode then return end -- make sure box mode is on

	-- new node type or fpos is empty (set by 'fpos = {}')
	if fpos.x == nil or pname ~= newnode.name then
		fpos = pos
		pname = newnode.name
	else
		inv = placer:get_inventory()
		itemstack = build_box(pos, placer, itemstack) -- build the cuboid
		placer:set_wielded_item(itemstack) -- update the inventory (remove used blocks)

		fpos = {} -- deliberate mode (dangerous)
		--fpos = pos -- continuous mode (very dangerous)
	end
end
)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not boxmode then return end

	if fpos.x == pos.x and fpos.y == pos.y and fpos.z == pos.z then
		fpos = {} -- when we dig a node, remove it from instafill
	end
end
)

minetest.register_chatcommand("box", {
	params = "",
	description = "box: box mode switch",
	func = function(name, param)
		boxmode = not boxmode
		fpos = {}
		minetest.chat_send_player(name, "You have "..(boxmode and "entered" or "exited").." box mode");
	end,
})
