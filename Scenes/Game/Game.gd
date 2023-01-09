extends Node2D

var map
var astar
var next_point_id = 0

func _ready():
	map = Navigation2DServer.map_create()
	Navigation2DServer.map_set_edge_connection_margin(get_world_2d().get_navigation_map(), 5)
	Navigation2DServer.map_set_active(get_world_2d().get_navigation_map(), true)

	astar = AStar2D.new()

func add_point(location):
	astar.add_point(next_point_id, location)
	next_point_id += 1

	return next_point_id - 1

func connect_points(a, b):
	astar.connect_points(a, b)
