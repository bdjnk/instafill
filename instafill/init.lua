local boxmode = false
local ppos = {}
local pname = ""

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
	if not boxmode then return end -- make sure boxmode is on

	-- new node type or ppos is empty (set by 'ppos = {}')
	if ppos.x == nil or pname ~= newnode.name then
		ppos = pos
		pname = newnode.name
	else
		local x1 = math.min(ppos.x, pos.x) -- smaller x
		local x2 = math.max(ppos.x, pos.x) -- larger x

		local y1 = math.min(ppos.y, pos.y)
		local y2 = math.max(ppos.y, pos.y)

		local z1 = math.min(ppos.z, pos.z)
		local z2 = math.max(ppos.z, pos.z)

		for nx = x1, x2 do
			for ny = y1, y2 do
				for nz = z1, z2 do
					local npos = {x=nx, y=ny, z=nz}
					--comment out the if for hungery mode (replaces all node types)
					if minetest.env:get_node(npos).name == "air" then
						minetest.env:add_node(npos, {name = pname})
					end
				end
			end
		end
		ppos = {} -- deliberate mode (dangerous)
		--ppos = pos -- continuous mode (very dangerous)
	end
end
)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if not boxmode then return end

	if ppos.x == pos.x and ppos.y == pos.y and ppos.z == pos.z then
		ppos = {} -- when we dig a node, remove it from instafill
	end
end
)

minetest.register_chatcommand("box", {
	params = "",
	description = "box: box mode switch",
	func = function(name, param)
		boxmode = not boxmode
		ppos = {}
		minetest.chat_send_player(name, "You have "..(boxmode and "entered" or "exited").." box mode");
	end,
})
