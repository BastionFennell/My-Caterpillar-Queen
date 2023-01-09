extends RigidBody2D

onready var nav = $Navigation2D

export (int) var health = 10
export (int) var speed = 50

var is_enemy = true

func damage(amount):
	var pitch = randf() * 0.4 + 0.8
	get_node("Hit").pitch_scale = pitch
	get_node("Hit").play()
	health -= amount
	if health <= 0:
		die()

func die():
	self.queue_free()

func get_next_step(path):
	var i = 0
	var step = path[i]
	while i < len(path) - 1 && global_position.distance_to(path[i]) < 5:
		i += 1
	
	return path[i]

func _integrate_forces(state):
	var target = get_node("/root/World/Player").global_position
	var path = Navigation2DServer.map_get_path(get_world_2d().get_navigation_map(), global_position, Vector2(800,10), true)
	if len(path):
		var next_step = get_next_step(path)

		var vec = global_position.direction_to(next_step)
		look_at(next_step)
	
		linear_velocity = vec * speed
