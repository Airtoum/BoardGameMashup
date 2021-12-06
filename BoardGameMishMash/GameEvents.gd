extends Node


signal game_state_switched # (new_game_state)

signal game_state_selecting_piece
signal game_state_selecting_space
signal game_state_selecting_number
signal game_state_animation
signal game_state_after_move
signal game_state_check_win

signal piece_selected # (piece)

signal highlight_spaces # (array[board_positions], moving_piece, array[placement_rules], array[can_move_into])
signal a_space_was_highlighted
signal unhighlight_spaces

signal space_selected # (space)

signal win
signal lose

signal next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func emit_game_state_switched(new_game_state):
	call_deferred("emit_signal", "game_state_switched", new_game_state)
