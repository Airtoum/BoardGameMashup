extends Node

class_name Space


var type = cons.SPACE_NONE
var board_position = Vector2(0,0)
var pieces = []

func add(new_piece):
	pieces.append(new_piece)
	
func remove(a_piece):
	pieces.erase(a_piece)

func my_world_position():
	pass
