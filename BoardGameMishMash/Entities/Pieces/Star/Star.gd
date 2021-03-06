extends GamePart



# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_check_win", self, "check_collected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()


func check_collected():
	if not is_inside_tree():
		return
	var my_pos = $PieceComponent.get_board_position()
	var is_win = board.is_there_piece_at("Meeple", my_pos)
	if is_win:
		self.remove_from_board()
		GameEvents.emit_signal("win")


func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false


func save_ent():
	return {"piece_type": self.piece_type,
			"is_sliding_tile": self.is_sliding_tile,
			"$PieceComponent.location": $PieceComponent.location}

func load_ent(data: Dictionary):
	self.piece_type = data["piece_type"]
	self.is_sliding_tile = data["is_sliding_tile"]
	$PieceComponent.location = data["$PieceComponent.location"]
