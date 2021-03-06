extends GamePart



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()

func _input(event):
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_PIECE:
		$PieceComponent.select()
		var my_board_position = $PieceComponent.get_board_position()
		var my_moves = [my_board_position + Vector2.UP,
						my_board_position + Vector2.RIGHT,
						my_board_position + Vector2.LEFT,
						my_board_position + Vector2.DOWN]
		$PieceComponent.highlight_spaces(my_moves, "Meeple", ["NoHole"], ["Star"])

func _on_Meeple_mouse_entered():
	moused_over = true


func _on_Meeple_mouse_exited():
	moused_over = false


func save_ent():
	return {"piece_type": self.piece_type,
			"is_sliding_tile": self.is_sliding_tile,
			"$PieceComponent.location": $PieceComponent.location}

func load_ent(data: Dictionary):
	self.piece_type = data["piece_type"]
	self.is_sliding_tile = data["is_sliding_tile"]
	$PieceComponent.location = data["$PieceComponent.location"]
