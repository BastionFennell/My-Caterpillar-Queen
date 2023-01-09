extends RigidBody2D

var speed = 200
var velocity = 0

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

func get_input():
	velocity = 	get_input_vector()
	velocity = velocity * speed

	if Input.is_action_just_pressed("start_tower"):
		get_node("/root/EventBus").tower_start()

func _integrate_forces(state):
		get_input()

		linear_velocity = velocity

