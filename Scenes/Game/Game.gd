extends Node2D

var map

func _ready():
	map = Navigation2DServer.map_create()
	Navigation2DServer.map_set_edge_connection_margin(get_world_2d().get_navigation_map(), 5)
	Navigation2DServer.map_set_active(get_world_2d().get_navigation_map(), true)
