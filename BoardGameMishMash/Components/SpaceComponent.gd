extends Node

class_name Space

var board

var type = cons.SPACE_NONE
var board_position = Vector2(0,0)
var pieces = []

var is_highighted = false

func _ready():
	get_parent().add_to_group("Space")
	GameEvents.connect("highlight_spaces", self, "highlight")

func add(new_piece):
	pieces.append(new_piece)
	
func remove(a_piece):
	pieces.erase(a_piece)

func my_world_position():
	pass

func highlight(position_array, piece):
	is_highighted = board_position in position_array
	
func select():
	if is_highighted:
		GameEvents.emit_game_state_switched(Global.game_states.ANIMATION)
		GameEvents.emit_signal("space_selected", self)
