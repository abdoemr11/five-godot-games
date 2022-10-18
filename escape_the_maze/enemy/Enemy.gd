extends "res://character/Character.gd"

func _ready():
	can_move = false
	facing = moves.keys()[randi() % 4]
	yield(get_tree().create_timer(.5), "timeout")
	can_move = true
	
func _process(delta):
	if can_move:
		var has_moved_successufully = move(facing)
		if not has_moved_successufully or randi() % 10 > 5:
			facing = moves.keys()[randi() % 4]
