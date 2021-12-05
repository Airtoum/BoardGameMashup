extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	GameEvents.connect("win", self, "on_win")


func on_win():
	visible = true
