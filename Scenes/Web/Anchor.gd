extends StaticBody2D

var region
var astar_id_a
var astar_id_b

func calc_mass():
	return 0

func _ready():
	var game = get_node("/root/World")
	var id = game.add_point(global_position)

	astar_id_a = id
	astar_id_b = id
