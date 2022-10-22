extends KinematicBody2D
#state variables
enum {IDLE, RUN, JUMP, HURT, DEAD}
var state

var anim
var new_anim

#movement variables
export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

var velocity = Vector2()
func _ready():
	change_state(IDLE)

func _physics_process(delta):
	velocity.y += gravity *delta
	get_input()
	
	if new_anim != anim:
		anim = new_anim
		$AnimationPlayer.play(anim)
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
func get_input():
	if state == HURT:
		return
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	velocity.x =0
	if right:
		velocity.x += run_speed
		$Sprite.flip_h = false
	if left:
		velocity.x -= run_speed
		$Sprite.flip_h = true
	
	if jump and is_on_floor():
#		change_state(JUMP)
		print("Jumping")
		velocity.y = jump_speed
		
	# Handle State transistions 
	#refer to the state diagram page 162
	if state == IDLE and velocity.x != 0:
		change_state(RUN)
	if state == RUN and velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, RUN] and !is_on_floor():
		change_state(JUMP)
	if state == JUMP and is_on_floor():
		change_state(IDLE)

	
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			new_anim = 'idle'
		RUN:
			new_anim = 'run'
		HURT:
			new_anim = 'hurt'
		JUMP:
			if velocity.y > 0:
				new_anim = 'jump_down'
			else:	
				new_anim = 'jump_up'
		DEAD:
			hide()
	print(state, " ", new_anim)
	

