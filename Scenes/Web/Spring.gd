extends DampedSpringJoint2D

onready var rect = get_node("Rect")
onready var color = get_node("Rect/Color")
onready var nav = get_node("Nav")

func _adjust_vertices(length):
	var na = get_node(node_a).get_node("Nav")
	var nb = get_node(node_b).get_node("Nav")
	var verts_a = na.navpoly.vertices
	var verts_b = nb.navpoly.vertices

	var vert0
	var vert1
	var vert2
	var vert3

	if not "is_web" in get_node(node_a):
		# Node A is an anchor
		var trans = rect.get_transform()
		vert0 = trans.xform(Vector2(0, -5))
		vert3 = trans.xform(Vector2(0, 5))
	else:
		vert0 = to_local(na.to_global(verts_a[1]))
		vert3 = to_local(na.to_global(verts_a[2]))

	if not "is_web" in get_node(node_b):
		# Node B is an anchor
		var trans = rect.get_transform()
		vert1 = trans.xform(Vector2(length, -5))
		vert2 = trans.xform(Vector2(length, 5))
	else:
		vert1 = to_local(nb.to_global(verts_b[0]))
		vert2 = to_local(nb.to_global(verts_b[3]))
	"""

	vert0 = Vector2(0, 5)
	vert3 = Vector2(0, -5)
	vert1 = Vector2(length, 5)
	vert2 = Vector2(length, -5)

	"""


	var verts = nav.navpoly.vertices

	verts[0] = vert0
	verts[1] = vert1
	verts[2] = vert2
	verts[3] = vert3

	# print(verts)
	# if Geometry.triangulate_polygon(verts).empty():
		# print(verts)

	nav.navpoly.vertices = verts

func _physics_process(delta):
	var start = get_node(node_a).get_node("B").global_position
	var end = get_node(node_b).get_node("A").global_position

	var length = start.distance_to(end)	
	color.rect_size.x = length	
	rect.global_position = start
	rect.look_at(end)

	_adjust_vertices(length)
