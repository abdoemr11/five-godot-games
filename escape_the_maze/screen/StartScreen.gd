extends Control

func _ready():
	$HighScore.text = "High Score: " + str(Global.high_score)
func _input(event):
	if event.is_action_pressed("ui_accept"):
		Global.new_game()
