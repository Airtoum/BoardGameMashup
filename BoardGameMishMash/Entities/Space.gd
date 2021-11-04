extends Node2D

class_name Space


var type = cons.SPACE_NONE
var position = Vector2(0,0)
var pieces = []

func add(piece):
	pieces.append(piece)
	
func remove(piece):
	pieces.erase(piece)
