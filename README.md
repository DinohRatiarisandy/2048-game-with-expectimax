# 2048-game-with-expectimax
 2048 game with expectimax algo for auto play (Botsolver).

This game is build with Godot Engine 4.2.2 stable. <br>
The heuristic function I use in the Expectimax algo is snake heuristic. So it block the highest value in bottom-left corner. <br>
<br>

	[2, 2**2, 2**3, 2**4],
	[2**8, 2**7, 2**6, 2**5],
	[2**9, 2**10,2**11, 2**12],
	[2**16, 2**15,2**14, 2**13]
