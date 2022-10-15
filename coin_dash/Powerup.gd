
extends Area2D

func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'scale',
		$AnimatedSprite.scale,
		$AnimatedSprite.scale * 3, .3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate',
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 0), .3,
		Tween.TRANS_QUAD,
		Tween.EASE_IN_OUT)
		
	
func pickup():
	#monitoring = false
	print(monitorable, monitoring)
	$Tween.start()


func _on_Tween_tween_completed(object, key):
	queue_free()


func _on_LifeTimer_timeout():
	queue_free()
