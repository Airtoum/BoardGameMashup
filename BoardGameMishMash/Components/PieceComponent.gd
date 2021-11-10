extends Node


class_name Piece


var board

var type = cons.PIECE_TEST
var location: Space = null

func _ready():
	get_parent().add_to_group("Piece")

func move_to_space(new_space: Space):
	location = new_space
	
func die():
	location.remove(self)

func my_space():
	return location.get_parent()
	
func space_world_position():
	if location:
		return my_space().position
	push_warning("Warning! " + get_parent().name + " is not on a space!")
	return get_parent().position

func move_to(grid_position):
	var new_space = board.get_space_at_pos(grid_position, false)
	if new_space:
		location = new_space.get_node("SpaceComponent")
	else:
		push_warning("Warning! Piece " + get_parent().name + " tried to move into a spot without a space!")
	
	
