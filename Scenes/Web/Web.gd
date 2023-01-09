extends RigidBody2D

var joint = preload("res://Scenes/Web/Pin.tscn")

var is_web = true

var attached_nodes_a = []
var attached_nodes_b = []
var a_is_top = true;
var calc_mass_again = true;
var is_suspended = false;
var prev_rotation
var base_mass = 0.05

var region

var linked
var total_mass = self.mass

onready var astar_id_a = "%s_astar_a" % name
onready var astar_id_b = "%s_astar_b" % name

func attach(node):
	if(node.position.y > position.y):
		get_bottom_nodes().push_back(node)
	else:
		get_top_nodes().push_back(node)

func get_top_nodes():
	#todo: determine which side is higher
	return attached_nodes_a
	
func get_bottom_nodes():
	#todo: determine which side is lower
	return attached_nodes_b
	
func calc_mass():
	if !calc_mass_again:
		return total_mass
	total_mass = self.mass 
	for node in get_bottom_nodes():
		total_mass += node.calc_mass()
	calc_mass_again = false;
	var color_num = 1 - (total_mass / 1)
	#modulate = Color(color_num, color_num, color_num)
	
	return total_mass
	


func init(linked_node):
	print("adding")
	print(linked_node)
	linked = linked_node

# Called when the node enters the scene tree for the first time.
func _ready():
	var game = get_node("/root/World")
	astar_id_a = game.add_point($A.global_position)
	astar_id_b = game.add_point($B.global_position)
	game.connect_points(astar_id_a, astar_id_b)
	prev_rotation = int(rotation_degrees)
	calc_mass();
	"""var j = joint.instance()
	print("joints")
	print(linked.get_path())
	print(get_path())
	j.node_a = linked.get_path()
	j.node_b = get_path()
	print(j)
	print(j.node_b)
	linked.add_child(j)
	
	print("doot")
	pass # Replace with function body."""
	
func _integrate_forces(state):
	
	#print(state)
	pass
	
func set_calc_mass_again():
	calc_mass_again = true
	for node in get_top_nodes():
		#print("node name")
		#print(node.get_filename())
		if(node.get_filename() == "res://Scenes/Web/Web.tscn"):
			#print("set_rec_call")
			node.set_calc_mass_again()
			
func check_rotation():
	var prev_normalized_rotation = (((prev_rotation % 360) + 360) % 360)
	var prev_b_top  =  (90 <= prev_normalized_rotation && prev_normalized_rotation < 270)
	var new_normalized_rotation = (((int(rotation_degrees) % 360) + 360) % 360)
	var new_b_top = (90 <= new_normalized_rotation && new_normalized_rotation < 270)
	
	if(linked == "debug"):
		print("top changed")
		print(prev_normalized_rotation)
		print(new_normalized_rotation)
		print(prev_b_top)
		print(new_b_top)

	if(prev_b_top != new_b_top):
		
		set_calc_mass_again()
	prev_rotation = int(rotation_degrees)

func add_tower(tower):
	add_child(tower)

	var new_mass = base_mass
	for c in get_children():
		if "mass" in c:
			new_mass += c.mass

	mass = new_mass
	set_calc_mass_again()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var astar = get_node("/root/World").astar
	if (linked == "debug"):
		get_node("/root/World/Label").set_text(str(total_mass))
	check_rotation()
	calc_mass()

	astar.set_point_position(astar_id_a, $A.global_position)
	astar.set_point_position(astar_id_b, $B.global_position)
#	pass
