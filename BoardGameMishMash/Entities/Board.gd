extends Node


export(Color) var background
export(NodePath) var top_board_path = NodePath()
export(NodePath) var mid_board_path = NodePath()
export(NodePath) var btm_board_path = NodePath()
onready var top_board: BoardLayer = get_node_or_null(top_board_path) as BoardLayer
onready var mid_board: BoardLayer = get_node_or_null(mid_board_path) as BoardLayer
onready var btm_board: BoardLayer = get_node_or_null(btm_board_path) as BoardLayer

export(NodePath) var entity_container_path
onready var entity_container = get_node(entity_container_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(background)
	# bottom layer, spaces
	if btm_board_path == NodePath():
		btm_board = get_node("BottomBoard")
	btm_board.generate_entitites(entity_container, self, false)
	btm_board.visible = false
	# middle layer, sliding tiles
	if mid_board_path == NodePath():
		mid_board = get_node_or_null("MiddleBoard")
	if mid_board:
		mid_board.generate_entitites(entity_container, self, true)
		mid_board.visible = false
	# top layer, pieces
	if top_board_path == NodePath():
		top_board = get_node("TopBoard")
	top_board.generate_entitites(entity_container, self, false)
	top_board.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# may return null
func get_space_at_pos(pos, is_hole = false):
	for entity in entity_container.get_children():
		if entity.is_in_group("Space"):
			var space = entity.get_node("SpaceComponent") as Space
			if space.board_position == pos:
				if is_hole and (entity as GamePart).piece_type == "HoleSpace":
					return entity
				if not is_hole and not (entity as GamePart).piece_type == "HoleSpace":
					#print(is_hole, " ", (entity as GamePart).piece_type)
					return entity
	return null
			

# use during runtime, not setup
func initialize_game_part(game_part, board_position, entity_scale):
	entity_container.add_child(game_part)
	(game_part as GamePart).set_board_variable(self)
	(game_part as GamePart).set_location(board_position)
	# this doesn't work for creating new spaces right now
	game_part.scale = entity_scale

func is_there_piece_at(piece_type, board_position):
	var the_space = get_space_at_pos(board_position)
	if not the_space:
		return false
	return (the_space.get_node("SpaceComponent") as Space).is_occupied_by(piece_type)
	
func get_piece_ids_on_space(which_space):
	var pieces = []
	for entity in entity_container.get_children():
		if entity.is_in_group("Piece"):
			if entity.get_node("PieceComponent").my_space() == which_space:
				pieces.append(entity.piece_type)
	return pieces

func get_neighbor_ids(board_position):
	var neighbors = [[],[],[],[],[],[],[],[],[]]
	var i = 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			var search_space = self.get_space_at_pos(board_position + Vector2(x, y))
			neighbors[i] = self.get_piece_ids_on_space(search_space)
			i += 1
	return neighbors
