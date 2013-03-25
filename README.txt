A mod for Minetest which enables a player to create a solid cube of a given type of node by placing two nodes of that type at opposite corners of the desired cube area. This also allows the creation of squares and lines of nodes.

Current design choices I've made are as follows: The nodes only replace "air" and "default:water" nodes. The two corner nodes must be placed deliberately, and not be the second corner node of a previous instafill. All generated nodes are taken from the inventory. If there aren't enough as many as possible will be placed.

All of these except the last are easily alterable. See the source (init.lua) for which lines to comment / uncomment.

I've also made it so instafill is toggled by means of the "/box" command. It's off by default ;)
