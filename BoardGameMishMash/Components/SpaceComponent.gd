extends Node

class_name Space

var board

var type = cons.SPACE_NONE
var board_position = Vector2(0,0)
var pieces = [] # piece components

var is_highighted = false

func _ready():
	get_parent().add_to_group("Space")
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")

func add(new_piece):
	pieces.append(new_piece)
	
func remove(a_piece):
	pieces.erase(a_piece)

func my_world_position():
	pass
	
func is_occupied():
	return pieces.size() > 0
	
func is_occupied_by(check_piece_type: String):
	for piece in pieces:
		if piece.get_parent().piece_type == check_piece_type:
			return true
	return false
	
# returns true if unoccupied, this is intended
func is_only_occupied_by(check_piece_types: Array):
	for piece in pieces:
		if not piece.get_piece_type() in check_piece_types:
			return false
	return true

func highlight(position_array, piece, placement_rules: Array, can_move_into: Array):
	var result = board_position in position_array
	if result:
		result = is_only_occupied_by(can_move_into)
	if result:
		GameEvents.emit_signal("a_space_was_highlighted")
	is_highighted = result
	
func unhighlight():
	is_highighted = false
	
func select():
	if is_highighted:
		GameEvents.emit_game_state_switched(Global.game_states.ANIMATION)
		GameEvents.emit_signal("space_selected", self)

func initialize_new_entity(game_part):
	self.board.initialize_game_part(game_part, board_position, get_parent().scale)
	GameEvents.emit_game_state_switched(Global.game_states.ANIMATION)
