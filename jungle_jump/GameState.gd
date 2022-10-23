extends Node

var num_levels = 2
var current_level = 1

var game_scene = 'res://Main.tscn'
var title_scene = "res://ui/TitleScreen.tscn"

func restart():
	get_tree().change_scene(title_scene)
	
func next_level():
	current_level += 1
	if current_level <= num_levels:
		get_tree().reload_current_scene()
