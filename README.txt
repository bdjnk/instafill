instafill
=========

A mod for Minetest which enables a player to create a solid cube of a given type of node by placing two nodes of that type at opposite corners of the desired cube. This also allows the creation of squares and lines of nodes.

Current design choices I've made are as follows: The nodes only replace "air" nodes. While the two initial nodes must come from your inventory, the rest are magically generated.

The first of these is easily alterable. The second was a result of my trouble understanding how to correctly access and utilize the inventory system from within a mod. Contributions are welcome.

I've also made it so instafill is toggled by means of the "/box" command. It's off by default ;)
