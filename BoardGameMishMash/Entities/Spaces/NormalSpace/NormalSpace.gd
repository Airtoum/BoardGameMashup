extends GamePart


export(Texture) var inverted_outline

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")

func setup():
	if board.invert_normal_spaces:
		$Outline.texture = inverted_outline

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
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_SPACE:
		$SpaceComponent.select()

func highlight(position_array, which_piece, placement_rules, can_move_into):
	$SpaceComponent.highlight(position_array, which_piece, placement_rules, can_move_into)
	#$Highlighted.visible = $SpaceComponent.is_highighted
	self.is_graphic_highlighted = $SpaceComponent.is_highlighted()
		
func unhighlight():
	#$Highlighted.visible = false
	self.is_graphic_highlighted = false

func _on_NormalSpace_mouse_entered():
	moused_over = true


func _on_NormalSpace_mouse_exited():
	moused_over = false


func save_ent():
	return {"piece_type": self.piece_type,
			"is_sliding_tile": self.is_sliding_tile,
			"$SpaceComponent.board_position": $SpaceComponent.board_position,
			"$SpaceComponent.pieces": $SpaceComponent.pieces.duplicate(),
			"$PieceComponent.location": $PieceComponent.location if get_node_or_null("PieceComponent") else null}

func load_ent(data: Dictionary):
	self.piece_type = data["piece_type"]
	self.is_sliding_tile = data["is_sliding_tile"]
	$SpaceComponent.board_position = data["$SpaceComponent.board_position"]
	$SpaceComponent.pieces = data["$SpaceComponent.pieces"]
	if get_node_or_null("PieceComponent"):
		$PieceComponent.location = data["$PieceComponent.location"]
