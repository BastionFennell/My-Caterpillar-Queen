extends Node2D

onready var player = get_node("/root/World/Player")

var tower
var ready_to_place = false

export (int) var MAX_PLACEMENT_DISTANCE = 300

func _process(_delta):
	if visible:
		global_position = get_global_mouse_position()
		var distance_from_player = global_position.distance_to(player.global_position)

		if distance_from_player > MAX_PLACEMENT_DISTANCE:
			modulate = "64ff0000"
		else:
			modulate = "64ffffff"

		if ready_to_place && Input.is_action_just_pressed("place_tower") && distance_from_player < MAX_PLACEMENT_DISTANCE:
			var new_tower = tower.duplicate()

			new_tower.global_position = get_global_mouse_position()
			new_tower.active = true
			get_node("/root/World").add_child(new_tower)

		if ready_to_place && Input.is_action_just_pressed("cancel_tower"):
			remove_child(tower)
			tower = null
			visible = false
			ready_to_place = false
		else:
			ready_to_place = true


func set_tower(tower_type):
	if tower && has_node(tower.name):
		call_deferred("remove_child", tower)

	tower = tower_type.instance()
	call_deferred("add_child", tower)
