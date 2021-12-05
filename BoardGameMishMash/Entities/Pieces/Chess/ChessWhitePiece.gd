extends GamePart


export(bool) var is_white

var can_take = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_white:
		can_take = ["ChessBlackPawn", "ChessBlackRook", "ChessBlackBishop", "ChessBlackQueen", "ChessBlackKnight", "ChessBlackKing"]

func generate_moves_line(pos, direction, length):
	var result = []
	for i in range(1, length + 1):
		var obstructing_pieces = self.board.get_pieces_at_pos(pos + direction * i)
		if obstructing_pieces.size() > 0:
			var all_takeable = true
			for piece in obstructing_pieces:
				if not piece in can_take:
					all_takeable = false
			if all_takeable:
				result.append(direction * i)
			return result
		result.append(direction * i)
	return result

func generate_rook_moves(pos, length):
	var arr = []
	arr += (generate_moves_line(pos, Vector2.UP, length))
	arr += (generate_moves_line(pos, Vector2.DOWN, length))
	arr += (generate_moves_line(pos, Vector2.LEFT, length))
	arr += (generate_moves_line(pos, Vector2.RIGHT, length))
	return arr
	
func generate_bishop_moves(pos, length):
	var arr = []
	arr += (generate_moves_line(pos, Vector2(1,1), length))
	arr += (generate_moves_line(pos, Vector2(1,-1), length))
	arr += (generate_moves_line(pos, Vector2(-1,1), length))
	arr += (generate_moves_line(pos, Vector2(-1,-1), length)) 
	return arr

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()

func _input(event):
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_PIECE:
		$PieceComponent.select()
		var my_board_position = $PieceComponent.get_board_position()
		var my_relative_moves = []
		match piece_type:
			"ChessWhitePawn":
				my_relative_moves = [Vector2.UP]
			"ChessWhiteRook":
				my_relative_moves += generate_rook_moves(my_board_position, 18)
			"ChessWhiteBishop":
				my_relative_moves += generate_bishop_moves(my_board_position, 18)
			"ChessWhiteQueen":
				my_relative_moves += generate_rook_moves(my_board_position, 18)
				my_relative_moves += generate_bishop_moves(my_board_position, 18)
			"ChessWhiteKnight":
				my_relative_moves = [Vector2(-2, -1),
									 Vector2(-2, 1),
									 Vector2(-1, -2),
									 Vector2(-1, 2),
									 Vector2(1, -2),
									 Vector2(1, 2),
									 Vector2(2, -1),
									 Vector2(2, 1),]
			"ChessWhiteKing":
				my_relative_moves += generate_rook_moves(my_board_position, 1)
				my_relative_moves += generate_bishop_moves(my_board_position, 1)
		print("MY RELATIVE MOVES: " + str(my_relative_moves) )
		var my_moves = []
		for rel_move in my_relative_moves:
			my_moves.append(my_board_position + rel_move)
		$PieceComponent.highlight_spaces(my_moves, self.piece_type, ["NoHole"], can_take)

func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false
