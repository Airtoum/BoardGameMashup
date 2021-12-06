extends GamePart


export(bool) var is_red


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_after_move", self, "fall")
	GameEvents.connect("game_state_check_win", self, "check_win")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()


func fall():
	var starting_position = $PieceComponent.get_board_position()
	var my_pos = starting_position
	var falling = true
	while falling:
		my_pos = $PieceComponent.get_board_position()
		var below_space = board.get_space_at_pos(my_pos + Vector2.DOWN)
		if not below_space or below_space.get_node("SpaceComponent").is_occupied():
			break
		$PieceComponent.move_to_space(below_space.get_node("SpaceComponent"))
	if my_pos != starting_position:
		GameEvents.emit_signal("game_state_after_move")

# helper function for checking win, for the token that's far away
func extend_check(pos, dx, dy):
	return board.is_there_piece_at(self.piece_type, pos + Vector2(dx, dy))

# win/lose if four tokens are in a row
func check_win():
	if not is_inside_tree():
		return
	var pos = $PieceComponent.get_board_position()
	var neighbors = board.get_neighbor_ids(pos)
	var bitmask = [false, false, false, false, false, false, false, false, false]
	for i in range(neighbors.size()):
		bitmask[i] = self.piece_type in neighbors[i]
	# 0 1 2
	# 3 4 5
	# 6 7 8
	var four_connected = false
	if ((bitmask[0] and bitmask[8] and (extend_check(pos, -2, -2) or extend_check(pos,  2,  2)) ) or 
		(bitmask[1] and bitmask[7] and (extend_check(pos,  0, -2) or extend_check(pos,  0,  2)) ) or
		(bitmask[2] and bitmask[6] and (extend_check(pos,  2, -2) or extend_check(pos, -2,  2)) ) or
		(bitmask[3] and bitmask[5] and (extend_check(pos, -2,  0) or extend_check(pos,  2,  0)) )):
		four_connected = true
	if four_connected:
		if self.piece_type == "RedToken":
			GameEvents.emit_signal("win")
		if self.piece_type == "YellowToken":
			GameEvents.emit_signal("lose")


func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false


func save_ent():
	return {"piece_type": self.piece_type,
			"is_sliding_tile": self.is_sliding_tile,
			"is_red": self.is_red,
			"$PieceComponent.location": $PieceComponent.location}

func load_ent(data: Dictionary):
	self.piece_type = data["piece_type"]
	self.is_sliding_tile = data["is_sliding_tile"]
	self.is_red = data["is_red"]
	$PieceComponent.location = data["$PieceComponent.location"]
