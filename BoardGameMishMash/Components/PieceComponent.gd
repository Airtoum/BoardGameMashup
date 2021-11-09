extends Node


class_name Piece


var type = cons.PIECE_TEST
var location: Space = null


func move_to(new_space: Space):
	location = new_space
	
func die():
	location.remove(self)

func my_space():
	return location.get_parent()
	
func space_world_position():
	return my_space().position
