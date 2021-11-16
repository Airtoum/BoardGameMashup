extends Node2D

class_name GamePart


export(String) var piece_type
export(bool) var hover_highlight

var board = null
var moused_over = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moused_over and hover_highlight:
		self.modulate = Color(1.5, 1.5, 1.5, 1)
	else:
		self.modulate = Color(1, 1, 1, 1)


func set_board_variable(board):
	self.board = board
	var piece_component = get_node_or_null("PieceComponent")
	var space_component = get_node_or_null("SpaceComponent")
	if piece_component:
		piece_component.board = board
	if space_component:
		space_component.board = board

func set_location(grid_position):
	var piece_component = get_node_or_null("PieceComponent")
	var space_component = get_node_or_null("SpaceComponent")
	if piece_component:
		piece_component.move_to(grid_position)
	if space_component:
		space_component.board_position = grid_position

func is_clicked_on(event):
	if event is InputEventMouseButton and moused_over:
		if event.button_index == BUTTON_LEFT and event.pressed:
			return true
	return false
