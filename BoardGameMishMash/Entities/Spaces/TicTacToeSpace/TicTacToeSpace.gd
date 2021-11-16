extends GamePart


export(PackedScene) var X


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")

func _input(event):
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_PIECE:
		var new_x_piece = X.instance()
		$SpaceComponent.initialize_new_entity(new_x_piece)
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_SPACE:
		$SpaceComponent.select()

func highlight(position_array, which_piece, placement_rules, can_move_into):
	$SpaceComponent.highlight(position_array, which_piece, placement_rules, can_move_into)
	$Highlighted.visible = $SpaceComponent.is_highighted
		
func unhighlight():
	$Highlighted.visible = false

func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false
