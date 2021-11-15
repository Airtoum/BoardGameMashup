extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_switched", self, "game_state_switched")


func game_state_switched(new_game_state):
	print("Event: game_state_switched to " + str(new_game_state))
	
func game_state_selecting_piece():
	print("Event: game_state_selecting_piece")
	
func game_state_selecting_space():
	print("Event: game_state_selecting_space")
	
func game_state_selecting_number():
	print("Event: game_state_selecting_number")
	
func game_state_animation():
	print("Event: game_state_animation")
	
func highlight_spaces(position_array, moving_piece):
	print("Event: highlight_spaces in positions " + str(position_array) + " for piece " + str(moving_piece))
