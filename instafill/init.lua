local boxmode = false
local ppos = {}
local pname = ""

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
  if not boxmode then return end
	if ppos.x == nil or pname ~= newnode.name then
		ppos = pos
		pname = newnode.name
	else
		local dx = math.abs(ppos.x - pos.x)
		local x1 = math.min(ppos.x, pos.x)
		local x2 = math.max(ppos.x, pos.x)

		local dy = math.abs(ppos.y - pos.y)
		local y1 = math.min(ppos.y, pos.y)
		local y2 = math.max(ppos.y, pos.y)

		local dz = math.abs(ppos.z - pos.z)
		local z1 = math.min(ppos.z, pos.z)
		local z2 = math.max(ppos.z, pos.z)

		for nx = x1, x2 do
			for ny = y1, y2 do
				for nz = z1, z2 do
					local npos = {x=nx, y=ny, z=nz}
					if minetest.env:get_node(npos).name == "air" then
						minetest.env:add_node(npos, {name = pname})
					end
				end
			end
		end
		ppos = {}
	end
end
)

minetest.register_on_dignode(function(pos, oldnode, digger)
	if oldnode.name == pname then
		if ppos == pos then
			ppos = {}
		end
	end
end
)

minetest.register_chatcommand("box", {
	params = "",
	description = "box: box mode switch",
	func = function(name, param)
		boxmode = not boxmode
		minetest.chat_send_player(name, "You have "..(boxmode and "entered" or "exited").." box mode");
	end,
})
