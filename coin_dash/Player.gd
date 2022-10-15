extends Area2D

signal pickup
signal hurt

export (int) var speed
var velocity = Vector2()
var screensize = Vector2(480, 720)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	
	position += velocity *delta
	
	#prevent the player from going outside the screen coordinate
	position.x = clamp(position.x, 50, screensize.x)
	position.y = clamp(position.y, 0, screensize.y - 50 )
	print(position)
	
	#control the animation
	if velocity.length() > 0 :
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1	
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1	
		
	if velocity.length() > 0 :
		velocity = velocity.normalized() * speed

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	
func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)


func _on_Area2D_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")
		die()
