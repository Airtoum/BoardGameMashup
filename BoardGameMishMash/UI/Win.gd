extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	GameEvents.connect("win", self, "on_win")
	GameEvents.connect("lose", self, "on_lose")
	GameEvents.connect("game_state_selecting_piece", self, "update_visible")


func on_win():
	if Global.game_state != Global.game_states.LOSE:
		visible = true
	call_deferred("update_visible")
	
func on_lose():
	visible = false
	call_deferred("update_visible")
	
func update_visible():
	visible = Global.game_state == Global.game_states.WIN
