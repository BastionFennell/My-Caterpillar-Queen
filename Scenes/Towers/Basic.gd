extends RigidBody2D

export (int) var damage = 2
export (float) var reload_time = 1
export (float) var reload_timer = 0

var bullet = preload("res://Scenes/Projectiles/Basic Bullet.tscn")
onready var attack_box = get_node("Attack Box")
var is_reloading = false
var active = false

func get_enemies_in_range():
	var enemies = []
	for a in attack_box.get_overlapping_bodies():
		if "is_enemy" in a && a.is_enemy:
			enemies.append(a)

	return enemies

func get_closest_enemy():
	var closest_enemy = null
	var distance_to_enemy = 10000000

	for a in attack_box.get_overlapping_bodies():
		if "is_enemy" in a && a.is_enemy:
			var curr_distance = global_position.distance_to(a.global_position)
			if curr_distance < distance_to_enemy:
				distance_to_enemy = curr_distance
				closest_enemy = a

	return closest_enemy

func attack():
	var enemy = get_closest_enemy()

	if !enemy:
		return

	look_at(enemy.global_position)
	var new_bullet = bullet.instance()
	new_bullet.target = enemy
	new_bullet.damage = damage
	new_bullet.global_position = global_position
	
	get_node("/root/World").add_child(new_bullet)

	is_reloading = true

func _process(delta):
	if is_reloading:
		reload_timer += delta
		if reload_timer >= reload_time:
			reload_timer = 0
			is_reloading = false
	else:
		if active:
			attack()

