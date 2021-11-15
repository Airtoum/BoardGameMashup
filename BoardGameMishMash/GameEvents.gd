extends Node


signal game_state_switched # (new_game_state)

signal game_state_selecting_piece
signal game_state_selecting_space
signal game_state_selecting_number
signal game_state_animation

signal highlight_spaces # (array[board_positions], moving_piece)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
