extends Node2D

export (NodePath) var target
export (int) var speed = 500

var MIN_DISTANCE = 10
var damage = 0
var wait_time = 5

var direction

func _ready():
	direction = global_position.direction_to(target.global_position)

	var timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true

	timer.connect("timeout", self, "_delete_self")

	add_child(timer)
	timer.start()

func _delete_self():
	queue_free()
	
func _process(delta):
	if !is_instance_valid(target):
		global_position = global_position + (direction * speed * delta)
		return

	var distance_to = global_position.distance_to(target.global_position) 	
	
	if distance_to <= MIN_DISTANCE:
		target.damage(damage)
		queue_free()
	else:
		direction = global_position.direction_to(target.global_position)
		#TODO: if direction vector overshoots, just move position to target

		global_position = global_position + (direction * speed * delta)
	
		
	
