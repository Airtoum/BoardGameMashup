extends TileMap

class_name BoardLayer

export(Array, PackedScene) var tilescenes: Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#special thanks to https://godotforums.org/discussion/22227/how-would-i-find-specific-tiles-on-the-tilemap-and-perform-an-action-on-each

func generate_entitites(container, board, is_middle):
	for tile_position in get_used_cells():
		var tile_id = get_cellv(tile_position)
		if get_cellv(tile_position) < tilescenes.size():
			var new_entity = tilescenes[tile_id].instance()
			container.add_child(new_entity)
			if is_middle:
				(new_entity as GamePart).setup_sliding_tile()
			(new_entity as GamePart).set_board_variable(board)
			(new_entity as GamePart).set_location(tile_position)
			new_entity.position = (self.map_to_world(tile_position) + self.cell_size / 2) * self.scale
			#deal with scale
			new_entity.scale = self.scale * 0.5
	
