extends Node2D

func _ready():
	$Label.set_text("abdo")
func _input(event):
	if event.is_action_pressed("shoot"):
		pass
