extends RigidBody2D

var screensize = Vector2()
var size
var radius
var scale_factor = 0.2

func start(pos, vel, _size):
	position = pos
	size = _size
	mass = 1.5 *scale_factor
	$Sprite.scale = Vector2(1, 1) * scale_factor *size
	radius = int($Sprite.texture.get_size().x/2 * scale_factor *size)
	var shape = CircleShape2D.new()
	shape.radius = radius
	$CollisionShape2D.shape = shape
	print (vel)
	linear_velocity = vel
	angular_velocity = rand_range(-1.5, 1.5)

func  _integrate_forces(state):
	var xform = state.get_transform()
	if xform.origin.x > screensize.x + radius:
		xform.origin.x = 0 - radius
	if xform.origin.x < 0 - radius:
		xform.origin.x = screensize.x + radius
		
	if xform.origin.y > screensize.y + radius:
		xform.origin.y = 0 - radius
	if xform.origin.y < 0 - radius:
		xform.origin.y = screensize.y + radius
	state.set_transform(xform)
