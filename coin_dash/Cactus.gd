extends Area2D

var screensize

func _on_Cactus_area_entered(area):
	if area.is_in_group("coins"):
			position = Vector2(rand_range(50, screensize.x),
		rand_range(0, screensize.y - 50))
