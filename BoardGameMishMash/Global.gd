extends Node


enum game_states {SELECT_PIECE, SELECT_SPACE, SELECT_NUMBER, ANIMATION, AFTER_MOVE, CHECK_WIN, WIN, LOSE}

var game_state = game_states.SELECT_PIECE

var selected_piece = []
var selected_space = null

var any_spaces_availible = false

var emitted_check_win_already = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_switched", self, "set_game_state")
	GameEvents.connect("piece_selected", self, "select_piece")
	GameEvents.connect("space_selected", self, "select_space")
	GameEvents.connect("game_state_animation", self, "call_deferred", ["end_animation"])
	GameEvents.connect("game_state_after_move", self, "call_deferred", ["end_after_move"])
	GameEvents.connect("game_state_check_win", self, "call_deferred", ["end_check_win"])
	GameEvents.connect("a_space_was_highlighted", self, "a_space_was_highlighted")
	GameEvents.connect("win", self, "win")
	GameEvents.connect("lose", self, "lose")


func _input(event):
	if event.is_action_pressed("cancel"):
		cancel_selection()
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
		game_state = game_states.SELECT_PIECE
		selected_piece = []
		selected_space = null
		any_spaces_availible = false

func set_game_state(new_game_state):
	game_state = new_game_state
	match new_game_state:
		game_states.SELECT_PIECE:
			GameEvents.emit_signal("game_state_selecting_piece")
			GameEvents.emit_signal("unhighlight_spaces")
		game_states.SELECT_SPACE:
			GameEvents.emit_signal("game_state_selecting_space")
			call_deferred("cancel_if_no_spaces_availible")
		game_states.SELECT_NUMBER:
			GameEvents.emit_signal("game_state_selecting_number")
		game_states.ANIMATION:
			GameEvents.emit_signal("game_state_animation")
			GameEvents.emit_signal("unhighlight_spaces")
		game_states.AFTER_MOVE:
			GameEvents.emit_signal("game_state_after_move")
		game_states.CHECK_WIN:
			GameEvents.emit_signal("game_state_check_win")
		game_states.WIN:
			pass
		game_states.LOSE:
			pass
			
func select_piece(piece):
	selected_piece.append(piece)
	
func select_space(space):
	selected_space = space
	
func is_piece_selected(piece):
	return piece in selected_piece
	
func is_space_selected(space):
	return space == selected_space
	
func cancel_selection():
	selected_piece = []
	selected_space = null
	any_spaces_availible = false
	GameEvents.emit_game_state_switched(game_states.SELECT_PIECE)

func a_space_was_highlighted():
	any_spaces_availible = true

func cancel_if_no_spaces_availible():
	if not any_spaces_availible:
		cancel_selection()

func terminal_state():
	return game_state in [game_states.WIN, game_states.LOSE]

func end_animation():
	if terminal_state():
		return
	GameEvents.emit_game_state_switched(game_states.AFTER_MOVE)
	
func end_after_move():
	if emitted_check_win_already:
		return
	emitted_check_win_already = true	
	GameEvents.emit_game_state_switched(game_states.CHECK_WIN)

func win():
	if game_state != game_states.LOSE:
		game_state = game_states.WIN
	
func lose():
	game_state = game_states.LOSE

func end_check_win():
	emitted_check_win_already = false
	if not game_state in [game_states.WIN, game_states.LOSE]:
		return_to_select_piece()

func return_to_select_piece():
	selected_piece = []
	selected_space = null
	any_spaces_availible = false
	GameEvents.emit_game_state_switched(game_states.SELECT_PIECE)
