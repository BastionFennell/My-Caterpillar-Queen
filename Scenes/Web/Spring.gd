extends DampedSpringJoint2D

onready var rect = get_node("Rect")
onready var color = get_node("Rect/Color")

func _process(delta):
	var start = get_node(node_a).get_node("B").global_position
	var end = get_node(node_b).get_node("A").global_position

	color.rect_size.x = start.distance_to(end)	
	rect.global_position = start
	rect.look_at(end)
