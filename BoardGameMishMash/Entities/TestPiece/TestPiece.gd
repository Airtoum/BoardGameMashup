extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = $PieceComponent.space_world_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = $PieceComponent.space_world_position()
