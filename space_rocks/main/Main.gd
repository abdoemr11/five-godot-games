extends Node2D

export (PackedScene) var Rock
var screensize = Vector2()
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.screen_size = screensize
	for i in range(3):
		spawn_rock(3)

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
	$Rocks.add_child(r)

func _on_Player_shoot(Bullet, pos, dir):
	var b = Bullet.instance()
	b.start(pos, dir)
	add_child(b)
