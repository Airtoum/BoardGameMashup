extends GamePart


export(PackedScene) var X


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")

func _process(delta):
	if moused_over and do_hover_highlight:
		if is_graphic_highlighted:
			$Highlighted.modulate = hover_and_highlight_color
		else:
			$Highlighted.modulate = hover_color
	else:
		if is_graphic_highlighted:
			$Highlighted.modulate = highlight_color
		else:
			$Highlighted.modulate = normal_color
	

func _input(event):
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_PIECE:
		if not $SpaceComponent.is_occupied():
			var new_x_piece = X.instance()
			$SpaceComponent.initialize_new_entity(new_x_piece)
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_SPACE:
		$SpaceComponent.select()

func highlight(position_array, which_piece, placement_rules, can_move_into):
	$SpaceComponent.highlight(position_array, which_piece, placement_rules, can_move_into)
	#$Highlighted.visible = $SpaceComponent.is_highighted
	is_graphic_highlighted = $SpaceComponent.is_highighted
		
func unhighlight():
	is_graphic_highlighted = false
	#$Highlighted.visible = false

func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false
