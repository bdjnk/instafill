A mod for Minetest which allows players to create a solid cube of a given type of node by placing two nodes of that type at opposite corners of the desired cube. This enables the easy creation of lines, planes, and rectagles of nodes.

Instafill is toggled by means of the "/f" command. Chat messages will let you know what state you're in.

## Specific Functionality

The cube nodes only replace "air" and "default:water" nodes. All other nodes are worked around; they will be encased, not replaced.

In **non**-creative mode all placed cube nodes are taken from the inventory. If there aren't enough of those nodes in the inventory, as many as possible will be placed.

In creative mode, all cube nodes will just appear, like magic.

Once the second node is placed and the cube if filled, you automatically exit fill mode. If you dig any node, you automatically exit fill mode. Remaining in fill mode unawares can lead to spectacular absurdity.

---

All of these are (fairly) easily alterable. See the source (init.lua) for which lines to comment / uncomment.
