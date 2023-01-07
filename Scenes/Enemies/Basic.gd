extends Node2D

export (int) var health = 10
var is_enemy = true

func damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	self.queue_free()