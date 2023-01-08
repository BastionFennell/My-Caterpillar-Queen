extends RigidBody2D

var start_timer

func _ready():
	get_node("Body/Leg 1").step(Vector2(global_position.x, get_node("Body/Leg 1").global_position.y - 115))
	get_node("Body/Leg 5").step(Vector2(global_position.x, get_node("Body/Leg 5").global_position.y - 115))
	get_node("Body/Leg 2").step(Vector2(global_position.x, get_node("Body/Leg 2").global_position.y - 95))
	get_node("Body/Leg 6").step(Vector2(global_position.x, get_node("Body/Leg 6").global_position.y - 95))
	get_node("Body/Leg 3").step(Vector2(global_position.x, get_node("Body/Leg 3").global_position.y - 65))
	get_node("Body/Leg 7").step(Vector2(global_position.x, get_node("Body/Leg 7").global_position.y - 65))
	get_node("Body/Leg 4").step(Vector2(global_position.x, get_node("Body/Leg 4").global_position.y - 50))
	get_node("Body/Leg 8").step(Vector2(global_position.x, get_node("Body/Leg 8").global_position.y - 50))

	start_timer = Timer.new()
	start_timer.wait_time = 3 * randf()
	start_timer.one_shot = true
	start_timer.connect("timeout", self, "_start_intro")

	add_child(start_timer)
	start_timer.start()

func _start_intro():
	get_node("Intro Animator").play("Intro")

	start_timer.queue_free()