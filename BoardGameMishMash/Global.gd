extends Node


enum game_states {SELECT_PIECE, SELECT_SPACE, SELECT_NUMBER, ANIMATION}

var game_state = game_states.SELECT_PIECE

var selected_piece = null
var selected_space = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_switched", self, "set_game_state")
	GameEvents.connect("piece_selected", self, "select_piece")
	GameEvents.connect("space_selected", self, "select_space")
	GameEvents.connect("game_state_animation", self, "end_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_game_state(new_game_state):
	game_state = new_game_state
	match new_game_state:
		game_states.SELECT_PIECE:
			GameEvents.emit_signal("game_state_selecting_piece")
		game_states.SELECT_SPACE:
			GameEvents.emit_signal("game_state_selecting_space")
		game_states.SELECT_NUMBER:
			GameEvents.emit_signal("game_state_selecting_number")
		game_states.ANIMATION:
			GameEvents.emit_signal("game_state_animation")
			
func select_piece(piece):
	selected_piece = piece
	
func select_space(space):
	selected_space = space

func end_animation():
	GameEvents.emit_game_state_switched(game_states.SELECT_PIECE)
