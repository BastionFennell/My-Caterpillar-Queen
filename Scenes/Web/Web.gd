extends Node2D

var joint = preload("res://Scenes/Web/Pin.tscn")

var attached_nodes_a = []
var attached_nodes_b = []
var a_is_top = true;
var calc_mass_again = true;
var is_suspended = false;
var prev_rotation

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var linked
var total_mass = self.mass

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
	modulate = Color(color_num, color_num, color_num)
	
	return total_mass
	


func init(linked_node):
	print("adding")
	print(linked_node)
	linked = linked_node

# Called when the node enters the scene tree for the first time.
func _ready():
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
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (linked == "debug"):
		get_node("/root/World/Label").set_text(str(total_mass))
	check_rotation()
	calc_mass()
#	pass