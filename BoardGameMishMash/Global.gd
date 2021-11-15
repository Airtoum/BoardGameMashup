extends Node


enum game_states {SELECT_PIECE, SELECT_SPACE, SELECT_NUMBER, ANIMATION, AFTER_MOVE}

var game_state = game_states.SELECT_PIECE

var selected_piece = null
var selected_space = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_switched", self, "set_game_state")
	GameEvents.connect("piece_selected", self, "select_piece")
	GameEvents.connect("space_selected", self, "select_space")
	GameEvents.connect("game_state_animation", self, "end_animation")


func _input(event):
	if event.is_action_pressed("cancel"):
		cancel_selection()

func set_game_state(new_game_state):
	game_state = new_game_state
	match new_game_state:
		game_states.SELECT_PIECE:
			GameEvents.emit_signal("game_state_selecting_piece")
			GameEvents.emit_signal("unhighlight_spaces")
		game_states.SELECT_SPACE:
			GameEvents.emit_signal("game_state_selecting_space")
		game_states.SELECT_NUMBER:
			GameEvents.emit_signal("game_state_selecting_number")
		game_states.ANIMATION:
			GameEvents.emit_signal("game_state_animation")
			GameEvents.emit_signal("unhighlight_spaces")
		game_states.AFTER_MOVE:
			GameEvents.emit_signal("game_state_after_move")
			
func select_piece(piece):
	selected_piece = piece
	
func select_space(space):
	selected_space = space
	
func cancel_selection():
	selected_piece = null
	selected_space = null
	GameEvents.emit_game_state_switched(game_states.SELECT_PIECE)

func end_animation():
	GameEvents.emit_game_state_switched(game_states.SELECT_PIECE)
