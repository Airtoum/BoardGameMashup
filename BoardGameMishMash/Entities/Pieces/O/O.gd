extends GamePart



# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_animation", self, "check_lose")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()


func check_lose():
	var my_pos = $PieceComponent.get_board_position()
	var neighbor_os = [false, false, false, false, true, false, false, false, false]
	# 0 1 2
	# 3 4 5
	# 6 7 8
	var i = 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			if x == 0 and y == 0:
				i += 1
				continue
			neighbor_os[i] = board.is_there_piece_at("O", my_pos + Vector2(x, y))
			i += 1
	var is_lose = (neighbor_os[0] and neighbor_os[8] or
				  neighbor_os[1] and neighbor_os[7] or
				  neighbor_os[2] and neighbor_os[6] or
				  neighbor_os[3] and neighbor_os[5])
	if is_lose:
		GameEvents.emit_signal("lose")


func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false
