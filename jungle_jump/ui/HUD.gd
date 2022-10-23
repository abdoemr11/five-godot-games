extends MarginContainer

onready var life_counter = [
	$HBoxContainer/LifeContainer/L1,
	$HBoxContainer/LifeContainer/L2,
	$HBoxContainer/LifeContainer/L3,
	$HBoxContainer/LifeContainer/L4,
	$HBoxContainer/LifeContainer/L5
]

func _on_Player_life_changed(value):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = value > heart

func _on_score_changed(value):
	$HBoxContainer/ScoreLabel.text = str(value)
