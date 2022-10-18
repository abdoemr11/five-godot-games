extends Node

var levels = [
	"res://levels/Level1.tscn",
	"res://levels/Level2.tscn"
]

var start_screen = 'res://screen/StartScreen.tscn'
var end_screen = "res://screen/EndScreen.tscn"

var current_level

var score

var high_score = 0
var score_file = 'user://highscore.txt'

func _ready():
	setup()
	
func setup():
	var f = File.new()
	if f.file_exists(score_file):
		f.open(score_file, File.READ)
		var content = f.get_as_text()
		high_score = int(content)
		f.close()
		
func new_game():
	current_level = -1
	score = 0
	next_level()
	
func next_level():
	current_level += 1
	if current_level >= Global.levels.size():
		game_over()
	else: 
		get_tree().change_scene(levels[current_level])
	
func game_over():
	if score > high_score:
		high_score = score
		save_score()
		
	get_tree().change_scene(end_screen)

func save_score():
	var f = File.new()
	f.open(score_file, File.WRITE)
	f.store_string(str(high_score))
	f.close()
