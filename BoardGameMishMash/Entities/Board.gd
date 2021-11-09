extends Node


export(NodePath) var top_board_path = NodePath()
export(NodePath) var mid_board_path = NodePath()
export(NodePath) var btm_board_path = NodePath()
onready var top_board: BoardLayer = get_node_or_null(top_board_path) as BoardLayer
onready var mid_board: BoardLayer = get_node_or_null(mid_board_path) as BoardLayer
onready var btm_board: BoardLayer = get_node_or_null(btm_board_path) as BoardLayer

export(NodePath) var entity_container_path = self.get_path()
onready var entity_container = get_node(entity_container_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	if btm_board_path == NodePath():
		btm_board = get_node("BottomBoard")
	btm_board.generate_entitites(entity_container)
	btm_board.visible = false
	if top_board_path == NodePath():
		top_board = get_node("TopBoard")
	top_board.generate_entitites(entity_container)
	top_board.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
