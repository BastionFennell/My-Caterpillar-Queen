extends Button

var end_next = false

func _ready():
	self.connect("mouse_entered", self, "_on_mouse_enter")
	self.connect("mouse_exited", self, "_on_mouse_exit")
	$Animator.connect("animation_finished", self, "_on_animation_finished")


func _on_mouse_enter():
	end_next = false
	$Animator.play("Hover")

func _on_mouse_exit():
	end_next = true

func _on_animation_finished(_anim):
	print("DOOT")
	if end_next:
		$Animator.stop()
		end_next = false
	else:
		$Animator.play("Hover")
