extends GamePart


export(PackedScene) var X

export(Array, Texture) var tiles


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")

func setup():
	var bitmask = board.is_adjacent_spaces_matching($SpaceComponent.board_position, false, self.piece_type)
	# 0 1 2
	# 3 4 5
	# 6 7 8
	var texture_index = int(bitmask[1]) + 2*int(bitmask[3]) + 4*int(bitmask[5]) + 8*int(bitmask[7])
	$Outline.texture = tiles[texture_index]


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
	is_graphic_highlighted = $SpaceComponent.is_highlighted()
		
func unhighlight():
	is_graphic_highlighted = false
	#$Highlighted.visible = false

func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
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
	$SpaceComponent.pieces = data["$SpaceComponent.pieces"].duplicate()
	if get_node_or_null("PieceComponent"):
		$PieceComponent.location = data["$PieceComponent.location"]
