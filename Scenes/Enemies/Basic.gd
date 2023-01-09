extends RigidBody2D

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

func _integrate_forces(state):
	var astar = get_node("/root/World").astar
	var current = astar.get_closest_point(global_position)
	var target = astar.get_closest_point(get_node("/root/World/Player").global_position)

	var astar_path = astar.get_point_path(current, target)
	if len(astar_path) > 1:
		var next_step = astar_path[1]

		var vec = global_position.direction_to(next_step)
		look_at(next_step)
	
		linear_velocity = vec * speed

		global_position = astar.get_closest_position_in_segment(global_position)


