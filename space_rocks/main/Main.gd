extends Node2D

export (PackedScene) var Rock

var screensize = Vector2()

#gameplay variables
var level = 0
var score = 0
var playing = false

func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screen_size = screensize
	for i in range(3):
		spawn_rock(3)
	get_viewport().connect("size_changed",self, "_on_Size_changed")

func _process(delta):
	#win level condition
	if playing and $Rocks.get_child_count() == 0:
		new_level()
		
func new_game():
	for r in $Rocks.get_children():
		r.queue_free()
		
	level = 0
	score = 0
	$HUD.update_score(score)
	
	$Player.start()
	
	$HUD.show_message("Get Ready !")
	yield($HUD/MessageTimer, "timeout")
	
	playing = true
	new_level()

func new_level():
	level+=1
	$HUD.show_message("Wave %s" % level)
	
	#spawn rocks according to the current level
	for i in range(level):
		spawn_rock(3)	

func game_over():
	playing = false
	$HUD.game_over()
	
func spawn_rock(size, pos=null, vel=null):
	#if there is no given position or velocity generate them randomly
	if !pos:
		$RockPath/RockSpawn.set_offset(randi())
		pos = $RockPath/RockSpawn.position
	if !vel:
		vel = Vector2(1, 0).rotated(rand_range(0, 2*PI))* rand_range(100, 150)
	
	var r = Rock.instance()
	r.screensize = screensize
	r.start(pos, vel, size)
	r.connect('exploded', self, '_on_Rock_exploded')
	$Rocks.add_child(r)

func _on_Rock_exploded(size, radius, pos, vel):
	if size <= 1:
		return
	for offset in [-1, 1]:
		var dir = ($Player.position - pos).normalized().tangent()*offset
		
		var newpos = pos + dir * radius
		var newvel = dir * vel.length() * 1.1 
		spawn_rock(size-1, newpos, newvel)
		
func _on_Player_shoot(Bullet, pos, dir):
	var b = Bullet.instance()
	b.start(pos, dir)
	add_child(b)


func _on_Size_changed():
	print("rect changed")
	screensize = get_viewport().get_visible_rect().size
	$Player.screen_size = screensize
	for r in $Rocks.get_children():
		r.screensize = screensize
