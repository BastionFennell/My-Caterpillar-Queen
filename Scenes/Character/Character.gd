extends RigidBody2D

var target
var speed = 200

func _ready():
	get_node("Body/Leg 1").step(Vector2(global_position.x, get_node("Body/Leg 1").global_position.y - 115))
	get_node("Body/Leg 5").step(Vector2(global_position.x, get_node("Body/Leg 5").global_position.y - 90))
	get_node("Body/Leg 2").step(Vector2(global_position.x, get_node("Body/Leg 2").global_position.y - 65))
	get_node("Body/Leg 6").step(Vector2(global_position.x, get_node("Body/Leg 6").global_position.y - 40))
	get_node("Body/Leg 3").step(Vector2(global_position.x, get_node("Body/Leg 3").global_position.y + 45))
	get_node("Body/Leg 7").step(Vector2(global_position.x, get_node("Body/Leg 7").global_position.y + 70))
	get_node("Body/Leg 4").step(Vector2(global_position.x, get_node("Body/Leg 4").global_position.y + 95))
	get_node("Body/Leg 8").step(Vector2(global_position.x, get_node("Body/Leg 8").global_position.y + 120))

func get_input_vector():
	var vec = Vector2()

	#if Input.is_action_pressed("ui_right"):
	#	vec.x += Input.get_action_strength("ui_right")
	#if Input.is_action_pressed("ui_left"):
	#	vec.x -= Input.get_action_strength("ui_left")
	if Input.is_action_pressed("ui_up"):
		vec.y -= Input.get_action_strength("ui_up")
	if Input.is_action_pressed("ui_down"):
		vec.y += Input.get_action_strength("ui_down")

	return vec.normalized()

func _integrate_forces(state):
	var astar = get_node("/root/World").astar
	if target:
		var current = astar.get_closest_point(global_position)
		var closest_target_point = astar.get_closest_point(target)

		var astar_path = astar.get_point_path(current, closest_target_point)
		if len(astar_path) > 1 && global_position.distance_to(astar_path[1]) > 10:
			var next_step = astar_path[1]
			var vec = global_position.direction_to(next_step)
			look_at(next_step)
			rotation += PI / 2
	
			linear_velocity = vec * speed
		else:
			target = null
			linear_velocity = Vector2(0, 0)

	global_position = astar.get_closest_position_in_segment(global_position)


func _process(_delta):
	if Input.is_action_just_pressed("click"):
		target = get_global_mouse_position()

	if Input.is_action_just_pressed("start_tower"):
		get_node("/root/EventBus").tower_start()