extends RigidBody2D

#for controlling the transition between Player ship states
enum {INIT, ALIVE, INVULNERABLE, DEAD}
var state

export (int) var engine_power
export (int) var spin_power

var thrust = Vector2()
var rotation_dir = 0

var screen_size = Vector2()

#shooting variable
signal shoot
export (PackedScene) var Bullet
export (float) var fire_rate
var can_shoot = true

signal lives_changed
signal dead
var lives = 0 setget set_lives

func _ready():
	change_state(INIT)
	screen_size = get_viewport().get_visible_rect().size
	$GunTimer.wait_time = fire_rate
	
func _process(delta):
	get_input()

func _integrate_forces(physics_state):
	set_applied_force(thrust.rotated(rotation))
	set_applied_torque(spin_power * rotation_dir)
	
	var xform = physics_state.get_transform()
	if xform.origin.x > screen_size.x:
		xform.origin.x = 0
	if xform.origin.x < 0:
		xform.origin.x = screen_size.x
	if xform.origin.y > screen_size.y:
		xform.origin.y = 0
	if xform.origin.y < 0:
		xform.origin.y = screen_size.y	
	physics_state.set_transform(xform)	
	
func get_input():
	thrust = Vector2()
	if state in [INIT, DEAD]:
		return
	if Input.is_action_pressed("thrust"):
		thrust = Vector2(engine_power, 0)
	
	rotation_dir = 0
	if Input.is_action_pressed("rotate_left"):
		rotation_dir = -1
	if Input.is_action_pressed("rotate_right"):
		rotation_dir = 1
	
	#fire input
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func start():
	$Sprite.show()
	self.lives = 2
	change_state(ALIVE)	
func shoot():
	if state == INVULNERABLE:
		return
	emit_signal("shoot", Bullet, $Muzzle.global_position, rotation)
	can_shoot = false
	$GunTimer.start()
	
func change_state(new_state):
	match new_state:
		INIT:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
		ALIVE:
			$CollisionShape2D.disabled = false
			$Sprite.modulate.a = 1.0
		INVULNERABLE:
			$CollisionShape2D.disabled = true
			$Sprite.modulate.a = 0.5
			$InvulerableTimer.start()
			
		DEAD:
			$CollisionShape2D.disabled = true
			$Sprite.hide()
			linear_velocity = Vector2()
			emit_signal("dead")
	state = new_state

func set_lives(value):
	lives = value
	print(lives)
	emit_signal("lives_changed", lives)
func _on_GunTimer_timeout():
	can_shoot = true


func _on_InvulerableTimer_timeout():
	change_state(ALIVE)


func _on_Player_body_entered(body):
	print($CollisionShape2D.disabled)
	if body.is_in_group("rocks"):
		body.explode()
		$Explosion.show()
		$Explosion/AnimationPlayer.play("explosion")
		self.lives -= 1
		if lives <=0:
			change_state(DEAD)
		else:
			change_state(INVULNERABLE)


func _on_AnimationPlayer_animation_finished(anim_name):
	$Explosion.hide()
