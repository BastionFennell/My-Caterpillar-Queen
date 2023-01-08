extends Node2D

onready var main_node = get_node("/root/World/Web")

var web = preload("res://Scenes/Web/Web.tscn")
var anchor = preload("res://Scenes/Web/Anchor.tscn")
var pin = preload("res://Scenes/Web/Pin.tscn")
var spring = preload("res://Scenes/Web/Spring.tscn")

var joint = spring

# Called when the node enters the scene tree for the first time.
func _ready():
	self.call_deferred("spawn_web", Vector2(10,10), Vector2(800,10))	
	
func spawn_web(position1, position2):
	var origin = main_node.global_position
	
	var start_anchor = create_anchor(position1)
	var end_anchor = create_anchor(position2)
	var caterpillar_anchor = create_anchor(Vector2((position1.x+position2.x)/2, 550))
	main_node.add_child(start_anchor)
	main_node.add_child(end_anchor)
	main_node.add_child(caterpillar_anchor)
	var middle = create_webs(start_anchor, end_anchor)
	create_webs(start_anchor, caterpillar_anchor)
	create_webs(end_anchor, caterpillar_anchor)
	create_webs(middle, caterpillar_anchor)
	
	
	#main_node.add_child(create_web_geometry())
	
func create_webs(start_node, end_node):
	var origin = main_node.global_position
	
	var parent = start_node;
	var x_pos = start_node.position.x
	var y_pos = start_node.position.y
	var x_dist = end_node.position.x - x_pos
	var y_dist = end_node.position.y - y_pos
	var web_segments = ceil(start_node.position.distance_to(end_node.position) / 100)
	var x_step = x_dist / web_segments
	var y_step = y_dist / web_segments
	
	var rotation_angle = start_node.position.angle_to_point(end_node.position)
	rotation_angle += PI / 2
	
	x_pos -= 50 * sin(rotation_angle)
	y_pos += 50 * cos(rotation_angle)
	
	
	var web_node = web.instance()
	#web_node.init("debug")
	web_node.set_rotation(rotation_angle)
	web_node.set_position(Vector2(x_pos, y_pos))
	web_node.attach(start_node)
	main_node.add_child(web_node)
	add_joint(parent, web_node, 5)
	parent = web_node
	var middle
	
	
	for i in range(web_segments-1):
		x_pos += x_step
		y_pos += y_step
		web_node = web.instance()
		web_node.set_rotation(rotation_angle)
		web_node.set_position(Vector2(x_pos, y_pos))
		web_node.attached_nodes_a.push_back(parent)
		parent.attached_nodes_b.push_back(web_node)
		parent.set_calc_mass_again();
	
		main_node.add_child(web_node)
		add_joint(parent, web_node, 50)
		parent = web_node
		if (i == int(web_segments/2)-1):
			middle = web_node
	
	parent.attached_nodes_b.push_back(end_node)
	add_joint(parent, end_node, 50)
	
	return middle
	
	#main_node.call_deferred("add_child", anchor_node)
	#main_node.call_deferred("add_child", web_node)
	
func create_anchor(position1):
	var anchor_node = anchor.instance()
	anchor_node.set_position(position1)
	return anchor_node
	
func create_web_geometry():
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(5, 1)
	collision.shape = shape
	return collision
	
func add_joint(parent, linked, off):
	var j = joint.instance()
	print(off)
	j.set_position(Vector2(0,off))
	j.node_a = parent.get_path()
	j.node_b = linked.get_path()
	parent.add_child(j)
	

	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
