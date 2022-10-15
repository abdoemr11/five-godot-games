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
	print(screensize)
	#$Player.screensize = screensize
	$Player.hide()



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
	$Player.show()
	$Player.start($PlayerStart.position)
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)

func game_over():
	playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	
	$HUD.show_game_over()
	$Player.die()	
	
func spawn_coins():
	for i in range(4+level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)

		c.position = Vector2(rand_range(0, screensize.x),
		rand_range(0, screensize.y))


func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0: 
		game_over()


func _on_Player_hurt():
	game_over()


func _on_Player_pickup():
	score+=1
	$HUD.update_score(score)


func _on_HUD_start_game():
	new_game()
