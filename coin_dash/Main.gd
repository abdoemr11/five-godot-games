extends Node2D

export (PackedScene) var Coin
export (int) var playtime

var level
var score
var time_left
var screensize
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	#$Player.hide()
	#for testing
	new_game()

func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		
func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start($PlayerStart.position)
	$GameTimer.start()
	spawn_coins()
	
func spawn_coins():
	for i in range(4+level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)

		c.position = Vector2(rand_range(0, screensize.x),
		rand_range(0, screensize.y))
