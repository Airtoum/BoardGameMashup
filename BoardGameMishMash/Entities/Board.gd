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

export(int) var promotion_rank_white
export(int) var promotion_rank_black

export(PackedScene) var next_level

export(bool) var override_colored_space
export(Color) var space_normal_color
export(Color) var space_hover_color
export(Color) var space_highlight_color
export(Color) var space_hover_and_highlight_color

export(bool) var invert_normal_spaces

var history = []

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_check_win", self, "call_deferred", ["record_board"])
	GameEvents.connect("next_level", self, "next_level")
	
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
	for space in get_tree().get_nodes_in_group("Space"):
		space.setup()
	record_board()


func _input(event):
	if event.is_action_pressed("undo"):
		undo()


# may return null or a single gamepart
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
	
func is_there_only_piece_at(piece_types, board_position):
	var the_space = get_space_at_pos(board_position)
	if not the_space:
		return false
	return (the_space.get_node("SpaceComponent") as Space).is_only_occupied_by(piece_types)
	
func must_only_piece_at(piece_types, board_position):
	var the_space = get_space_at_pos(board_position)
	if not the_space:
		return false
	return (the_space.get_node("SpaceComponent") as Space).must_only_occupied_by(piece_types)
	
# returns array of gameparts
func get_piece_ids_on_space(which_space):
	var pieces = []
	for entity in entity_container.get_children():
		if entity.is_in_group("Piece"):
			if entity.get_node("PieceComponent").my_space() == which_space:
				pieces.append(entity.piece_type)
	return pieces

# returns array of gameparts
func get_pieces_at_pos(pos, is_hole = false):
	return get_piece_ids_on_space(get_space_at_pos(pos, is_hole))

func get_neighbor_ids(board_position):
	var neighbors = [[],[],[],[],[],[],[],[],[]]
	var i = 0
	for y in [-1, 0, 1]:
		for x in [-1, 0, 1]:
			var search_space = self.get_space_at_pos(board_position + Vector2(x, y))
			neighbors[i] = self.get_piece_ids_on_space(search_space)
			i += 1
	return neighbors

func get_adjacent_spaces(board_position, is_hole):
	var result = [null, null, null, null, null, null, null, null, null]
	result[0] = (get_space_at_pos(board_position + Vector2(-1, -1), is_hole))
	result[1] = (get_space_at_pos(board_position + Vector2(0, -1), is_hole))
	result[2] = (get_space_at_pos(board_position + Vector2(1, -1), is_hole))
	result[3] = (get_space_at_pos(board_position + Vector2(-1, 0), is_hole))
	result[4] = (get_space_at_pos(board_position + Vector2(0, 0), is_hole))
	result[5] = (get_space_at_pos(board_position + Vector2(1, 0), is_hole))
	result[6] = (get_space_at_pos(board_position + Vector2(-1, 1), is_hole))
	result[7] = (get_space_at_pos(board_position + Vector2(0, 1), is_hole))
	result[8] = (get_space_at_pos(board_position + Vector2(1, 1), is_hole))
	return result
	
func is_adjacent_spaces_matching(board_position, is_hole, which_type):
	var neighbors = get_adjacent_spaces(board_position, is_hole)
	var result = [false, false, false, false, false, false, false, false, false]
	for i in range(neighbors.size()):
		var n = neighbors[i]
		if n:
			result[i] = n.piece_type == which_type
	return result

func record_board():
	var saved_board_state = {}
	for entity in entity_container.get_children():
		saved_board_state[entity] = ((entity as GamePart).save_ent())
	history.append(saved_board_state)

func undo():
	if history.size() <= 1:
		return
	history.pop_back()
	var load_state: Dictionary = history[-1]
	var entities_to_load = load_state.duplicate()
	for entity in entity_container.get_children():
		if not entity in load_state:
			(entity as GamePart).remove_from_board()
		else:
			(entity as GamePart).load_ent(load_state[entity])
			entities_to_load[entity] = null
	# reparent all entities that weren't in entity_container but need to be loaded
	for entity in entities_to_load:
		if entities_to_load[entity] != null:
			entity_container.add_child(entity)
			entity.load_ent(entities_to_load[entity])
	Global.cancel_selection()

func next_level():
	get_tree().change_scene_to(next_level)
