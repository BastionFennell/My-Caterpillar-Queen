extends DampedSpringJoint2D

onready var rect = get_node("Rect")
onready var color = get_node("Rect/Color")

func _ready():
	var game = get_node("/root/World")
	var point_a = get_node(node_a).astar_id_b
	var point_b = get_node(node_b).astar_id_a

	game.connect_points(point_a, point_b)

func _physics_process(delta):
	var start = get_node(node_a).get_node("B").global_position
	var end = get_node(node_b).get_node("A").global_position

	var length = start.distance_to(end)	
	color.rect_size.x = length	
	rect.global_position = start
	rect.look_at(end)
