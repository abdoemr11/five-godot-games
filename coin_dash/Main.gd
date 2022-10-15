extends Node2D

export (PackedScene) var Coin
export (int) var playtime
export (PackedScene) var PowerUp
export (PackedScene) var Obstacle
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
	
	$Sounds/EndSound.play()
	
	$HUD.show_game_over()
	$Player.die()	
	
func spawn_coins():
	for i in range(4+level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)

		c.position = Vector2(rand_range(50, screensize.x),
		rand_range(0, screensize.y - 50))
		
	$Sounds/LevelSound.play()
	
	$PowerUpTimer.wait_time = rand_range(5, 10)
	$PowerUpTimer.start()
	
	$ObstacleTimer.wait_time = rand_range(5, 10)
	$ObstacleTimer.start()

func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0: 
		game_over()


func _on_Player_hurt():
	game_over()


func _on_Player_pickup(type):
	match type:
		"coin":	
			score+=1
			$Sounds/CoinSound.play()
			$HUD.update_score(score)
		"powerup":
			time_left += 5
			$Sounds/PowerUpSound.play()
			$HUD.update_timer(time_left)


func _on_HUD_start_game():
	new_game()


func _on_PowerUpTimer_timeout():
	print("Power up is intializeing")
	var p = PowerUp.instance()
	$Powerups.add_child(p)
	p.position = Vector2(rand_range(50, screensize.x),
		rand_range(0, screensize.y - 50))


func _on_ObstacleTimer_timeout():
	print("Obstacle up is intializeing")
	var o = Obstacle.instance()
	$Powerups.add_child(o)
	o.position = Vector2(rand_range(50, screensize.x),
		rand_range(0, screensize.y - 50))
	o.screensize = screensize
