extends GamePart


export(bool) var is_red


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("game_state_animation", self, "fall")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.position = $PieceComponent.space_world_position()


func fall():
	var starting_position = $PieceComponent.get_board_position()
	var my_pos = starting_position
	var falling = true
	while falling:
		my_pos = $PieceComponent.get_board_position()
		var below_space = board.get_space_at_pos(my_pos + Vector2.DOWN)
		if not below_space or below_space.get_node("SpaceComponent").is_occupied():
			break
		$PieceComponent.move_to_space(below_space.get_node("SpaceComponent"))
	if my_pos != starting_position:
		GameEvents.emit_signal("game_state_animation")


func _on_mouse_entered():
	moused_over = true


func _on_mouse_exited():
	moused_over = false
