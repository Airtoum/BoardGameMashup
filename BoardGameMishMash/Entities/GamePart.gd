extends Node2D

class_name GamePart


export(String) var piece_type
export(bool) var override_highlighting = false
export(Color) var normal_color
export(Color) var hover_color
export(Color) var highlight_color
export(Color) var hover_and_highlight_color
export(bool) var do_hover_highlight
onready var PieceComponent = load("res://Components/PieceComponent.tscn")

var board = null
var moused_over = false
var is_graphic_highlighted = false
var is_sliding_tile = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if override_highlighting:
		return
	if moused_over and do_hover_highlight:
		if is_graphic_highlighted:
			self.modulate = hover_and_highlight_color
		else:
			self.modulate = hover_color
	else:
		if is_graphic_highlighted:
			self.modulate = highlight_color
		else:
			self.modulate = normal_color


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
		piece_component.move_to(grid_position, is_sliding_tile)
	if space_component:
		space_component.board_position = grid_position
		
func setup_sliding_tile():
	is_sliding_tile = true
	var sliding_piece_component = PieceComponent.instance()
	add_child(sliding_piece_component)
	var piece_component = get_node_or_null("PieceComponent")
	var space_component = get_node_or_null("SpaceComponent")
	if piece_component:
		piece_component.is_sliding_tile = true
	if space_component:
		space_component.is_sliding_tile = true
	z_index += 2
		
func setup():
	pass

func is_clicked_on(event):
	if event is InputEventMouseButton and moused_over:
		if event.button_index == BUTTON_LEFT and event.pressed:
			return true
	return false

func transfer_board_pos():
	var piece_component = get_node_or_null("PieceComponent")
	var space_component = get_node_or_null("SpaceComponent")
	if piece_component and space_component:
		space_component.board_position = piece_component.get_board_position()
		
func remove_from_board():
	var piece_component = get_node_or_null("PieceComponent")
	var space_component = get_node_or_null("SpaceComponent")
	if piece_component:
		piece_component.die()
	#self.queue_free()
	get_parent().remove_child(self)
	
# override me!
func all_make_move():
	pass

# override me!
func save_ent():
	return {"piece_type": self.piece_type,
			"is_sliding_tile": self.is_sliding_tile}

# override me!
func load_ent(data: Dictionary):
	self.piece_type = data["piece_type"]
	self.is_sliding_tile = data["is_sliding_tile"]
