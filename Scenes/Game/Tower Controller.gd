extends Node2D

onready var tower_preview = get_node("Tower Preview")

var towers = {
	"basic": preload("res://Scenes/Towers/Basic.tscn")
}

var current_tower

func _ready():
	get_node("/root/EventBus").connect("tower_start", self, "tower_start")

func tower_start():
	# Open tower select menu
	# Pick tower
	# Show tower at cursor
	# click to place tower
	current_tower = towers.basic
	tower_preview.set_tower(current_tower)
	tower_preview.visible = true