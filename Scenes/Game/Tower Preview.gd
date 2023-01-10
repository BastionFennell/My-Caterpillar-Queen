extends Node2D

onready var player = get_node("/root/World/Player")

var tower
var ready_to_place = false
onready var web_range = get_node("Area2D")

export (int) var MAX_PLACEMENT_DISTANCE = 300
export (int) var MAX_WEB_SNAP = 50

func _get_closest_web():
	var mouse = get_global_mouse_position()
	web_range.global_position = mouse
	var closest_web = null
	var closest_web_dist = 1000000

	for b in web_range.get_overlapping_bodies():
		if "is_web" in b and b.is_web:
			var dist = b.global_position.distance_to(mouse)
			if dist < closest_web_dist:
				closest_web_dist = dist
				closest_web = b

	return closest_web


func _process(_delta):
	# Snap to closest web segment
	# Find closest web segment
	# If no web segment within x pixel, error
# else
# place self at center of segment
	if visible:
		var closest_web = _get_closest_web()

		if Input.is_action_just_pressed("cancel_tower"):
			remove_child(tower)
			tower = null
			visible = false

		if closest_web && !closest_web.has_node("Tower"):
			var distance_from_player = global_position.distance_to(player.global_position)
			global_position = closest_web.global_position

			if distance_from_player > MAX_PLACEMENT_DISTANCE:
				modulate = "64ff0000"
			else:
				modulate = "64ffffff"

			if Input.is_action_just_pressed("place_tower") && distance_from_player < MAX_PLACEMENT_DISTANCE:
				var new_tower = tower.duplicate()

				new_tower.active = true
				new_tower.name = "Tower"
				closest_web.add_tower(new_tower)
		else:
			global_position = get_global_mouse_position()
			modulate = "64ff0000"


func set_tower(tower_type):
	if tower && has_node(tower.name):
		call_deferred("remove_child", tower)

	tower = tower_type.instance()
	call_deferred("add_child", tower)
