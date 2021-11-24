extends Node


class_name Piece


var board
var is_sliding_tile

var type = cons.PIECE_TEST
var location: Space = null

func _ready():
	get_parent().add_to_group("Piece")
	GameEvents.connect("game_state_animation", self, "all_make_move")

func move_to_space(new_space: Space):
	if location:
		location.remove(self)
	location = new_space
	new_space.add(self)
	
func die():
	location.remove(self)

func my_space():
	return location.get_parent()
	
func get_piece_type():
	return get_parent().piece_type
	
func space_world_position():
	if location:
		return my_space().position
	push_warning("Warning! " + get_parent().name + " is not on a space!")
	return get_parent().position

func move_to(grid_position, look_for_hole = false):
	var new_space = board.get_space_at_pos(grid_position, look_for_hole)
	if new_space:
		move_to_space(new_space.get_node("SpaceComponent"))
	else:
		push_warning("Warning! Piece " + get_parent().name + " tried to move into a spot without a space!")
	
func get_board_position():
	if location:
		return location.board_position
		
func select():
	GameEvents.emit_game_state_switched(Global.game_states.SELECT_SPACE)
	GameEvents.emit_signal("piece_selected", self)

func highlight_spaces(position_array, which_piece, placement_rules, can_move_into):
	GameEvents.emit_signal("highlight_spaces", position_array, which_piece, placement_rules, can_move_into)

func all_make_move():
	if Global.selected_piece == self:
		move_to_space(Global.selected_space)
