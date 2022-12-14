extends Area2D

export (int) var speed
var tile_size = 64
var can_move = true
var facing = 'right'
var moves = {
	'right': Vector2(1, 0),
	'left': Vector2(-1, 0),
	'up': Vector2(0, -1),
	'down': Vector2(0, 1),
	
}
onready var raycasts = {
	'right': $RayCastRight,
	'left': $RayCastLeft,
	'up': $RayCastUp,
	'down': $RayCastDown,
}

func move(dir):
	$AnimationPlayer.playback_speed = speed
	facing = dir
	#check if the character can move to the wanted dir
	if raycasts[facing].is_colliding():
		return
	can_move = false
	$AnimationPlayer.play(facing)
	$MoveTween.interpolate_property(self, "position",
				position, position + tile_size * moves[facing],
				1.0/ speed, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$MoveTween.start()
	return true


func _on_MoveTween_tween_completed(object, key):
	can_move = true
