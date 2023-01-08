extends Node2D

onready var spawn_points = get_node("../Spawn Points")

export (float) var time_to_spawn = 1

var enemies = {
	"basic": preload("res://Scenes/Enemies/Basic.tscn")
}
var timer = 0

func _spawn_enemy():
	var spawners = spawn_points.get_children()
	var spawn_from = randi() % len(spawners)

	var spawn_position = spawners[spawn_from].global_position

	var new_enemy = enemies.basic.instance()
	new_enemy.global_position = spawn_position
	get_node("/root/World").add_child(new_enemy)

func _process(delta):
	if timer < time_to_spawn:
		timer += delta
	else:
		timer = 0
		_spawn_enemy()
