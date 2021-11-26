extends Node

class_name Space

var board
var is_sliding_tile

var type = cons.SPACE_NONE
var board_position = Vector2(0,0)
var pieces = [] # piece components

var is_highighted_set = []

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
	if result and "NoHole" in placement_rules:
		result = get_parent().piece_type != "HoleSpace"
	if result and "OnlyHole" in placement_rules:
		result = get_parent().piece_type == "HoleSpace"
	if result:
		result = is_only_occupied_by(can_move_into)
	if result:
		GameEvents.emit_signal("a_space_was_highlighted")
	if result:
		is_highighted_set.append(piece)
	
func unhighlight():
	is_highighted_set.clear()
	
func is_highlighted():
	return not is_highighted_set.empty()
	
func is_highlighted_for(piece):
	return piece in is_highighted_set
	
func select():
	if not is_highighted_set.empty():
		GameEvents.emit_game_state_switched(Global.game_states.ANIMATION)
		GameEvents.emit_signal("space_selected", self)

func initialize_new_entity(game_part):
	self.board.initialize_game_part(game_part, board_position, get_parent().scale)
	GameEvents.emit_game_state_switched(Global.game_states.ANIMATION)
