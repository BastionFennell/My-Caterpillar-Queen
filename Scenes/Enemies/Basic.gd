extends RigidBody2D

export (int) var health = 10
export (int) var speed = 30

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
	var target = get_node("/root/World/Player").global_position
	var vec = global_position.direction_to(target)
	look_at(target)
	
	linear_velocity = vec * speed
