extends Node2D


class_name Piece


var type = cons.PIECE_TEST
var location: Space = null


func move_to(new_space: Space):
	location = new_space
	
func die():
	location.remove(self)
