extends RigidBody2D

var speed = 200
var velocity = 0

func _ready():
	get_node("Body/Leg 1").step(Vector2(global_position.x, global_position.y - 100))
	get_node("Body/Leg 2").step(Vector2(global_position.x, global_position.y - 50))
	get_node("Body/Leg 3").step(Vector2(global_position.x, global_position.y + 25))
	get_node("Body/Leg 4").step(Vector2(global_position.x, global_position.y + 75))
	get_node("Body/Leg 5").step(Vector2(global_position.x, global_position.y - 75))
	get_node("Body/Leg 6").step(Vector2(global_position.x, global_position.y - 25))
	get_node("Body/Leg 7").step(Vector2(global_position.x, global_position.y + 50))
	get_node("Body/Leg 8").step(Vector2(global_position.x, global_position.y + 100))

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

func _integrate_forces(state):
		get_input()

		linear_velocity = velocity
