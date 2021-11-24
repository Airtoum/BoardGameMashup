extends GamePart


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("highlight_spaces", self, "highlight")
	GameEvents.connect("unhighlight_spaces", self, "unhighlight")
	
func _process(delta):
	if is_sliding_tile:
		self.position = $PieceComponent.space_world_position()

func _input(event):
	if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_SPACE:
		$SpaceComponent.select()
	if is_sliding_tile:
		var PieceComponent = get_node_or_null("PieceComponent")
		if is_clicked_on(event) and Global.game_state == Global.game_states.SELECT_PIECE:
			PieceComponent.select()
			var my_board_position = PieceComponent.get_board_position()
			var my_moves = [my_board_position + Vector2.UP,
							my_board_position + Vector2.RIGHT,
							my_board_position + Vector2.LEFT,
							my_board_position + Vector2.DOWN]
			PieceComponent.highlight_spaces(my_moves, "ColoredSpace", ["OnlyHole"], [])

func highlight(position_array, which_piece, placement_rules, can_move_into):
	$SpaceComponent.highlight(position_array, which_piece, placement_rules, can_move_into)
	$Highlighted.visible = $SpaceComponent.is_highighted
		
func unhighlight():
	$Highlighted.visible = false

func _on_NormalSpace_mouse_entered():
	moused_over = true


func _on_NormalSpace_mouse_exited():
	moused_over = false
