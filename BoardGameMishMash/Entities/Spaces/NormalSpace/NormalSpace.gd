extends GamePart


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func highlight(position_array, which_piece):
	$Highlighted.visible = $SpaceComponent.board_position in position_array
		
