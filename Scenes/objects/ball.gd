class_name Ball
extends CharacterBody2D

@export var speed = 300.0
@export var gravity_scale = 0.4
@export var friction = 300
@export var air_resistance = 200
@export var bounce = 0.6

var collision: KinematicCollision2D
var direction = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	apply_gravity(delta)
	apply_friction(delta)
	apply_air_resistance(delta)
	
	var collision_info = move_and_collide(velocity * delta)
	handle_bounce(collision_info)
#	print (linear_velocity.length())
	
#	check if player or kick has touced the ball
#		allow access to speed 1
#	check if kick has touched the ball and if speed is speed 1
#		allow access to speed 2

# clamp the speed inbetween each level eg. speed 0 can max at 100 speed, level 1 can max at 200 speed, level 2 can max at 400 speed 

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * gravity_scale * delta

func apply_friction(delta):
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_air_resistance(delta):
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, air_resistance * delta)

func handle_bounce(collision_info):
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal()) * bounce
		

func push_ball(velocity_vector):
	velocity = velocity_vector
