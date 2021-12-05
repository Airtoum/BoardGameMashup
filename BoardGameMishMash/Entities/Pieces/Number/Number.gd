extends GamePart


export(int) var number
export(Array, Texture) var ordered_textures

var base_piece_type

# Called when the node enters the scene tree for the first time.
func _ready():
	self.base_piece_type = piece_type
	self.piece_type = piece_type + str(number)
	$Sprite.texture = ordered_textures[number]
	GameEvents.connect("game_state_animation", self, "check_win")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()

# shorthand
func num(n):
	return base_piece_type + str(n)

func check_win():
	if number != 5:
		return
	var my_pos = $PieceComponent.get_board_position()
	var neighbors = self.board.get_neighbor_ids(my_pos)
	# 0 1 2
	# 3 4 5
	# 6 7 8
	print(neighbors)
	var is_win = (num(1) in neighbors[0] and num(2) in neighbors[1] and num(3) in neighbors[2] and
				  num(4) in neighbors[3] and num(5) in neighbors[4] and num(6) in neighbors[5] and
				  num(7) in neighbors[6] and num(8) in neighbors[7])
	if is_win:
		GameEvents.emit_signal("win")


func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false