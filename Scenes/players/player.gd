class_name Player

extends CharacterBody2D

@export var movement_data : PlayerMovementData
@export var input_data : PlayerInputData

@export var kick_hit_box: KickHitBox
@export var player_sprite: AnimatedSprite2D
@export var wall_jump_timer: Timer


var can_kick: bool = true
var direction_facing: Vector2 = Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_gravity_scale: float
var stored_wall_normal = Vector2.ZERO

func _physics_process(delta):
	apply_gravity(delta)
	handle_wall_jump()
	handle_jump()
	var input_axis = Input.get_axis(input_data.left, input_data.right)
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animations(input_axis)
	var was_on_wall = is_on_wall_only()
	if was_on_wall:
		stored_wall_normal = get_wall_normal()
	move_and_slide()
	header()
	var just_left_wall = was_on_wall and not is_on_wall_only()
	if just_left_wall:
		wall_jump_timer.start()
		
	check_direction_input()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta

func handle_wall_jump():
	if not is_on_wall_only() and wall_jump_timer.time_left <= 0: return
	var wall_normal = get_wall_normal()
	if wall_jump_timer.time_left > 0:
		wall_normal = stored_wall_normal
	if Input.is_action_just_pressed(input_data.jump):
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity
	
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed(input_data.jump):
			velocity.y = movement_data.jump_velocity
	elif not is_on_floor():
		if Input.is_action_just_released(input_data.jump) and velocity.y < movement_data.min_jump_velocity:
			velocity.y = movement_data.min_jump_velocity

func handle_acceleration(input_axis, delta):
	if not is_on_floor(): return
	if input_axis:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
		

func handle_air_acceleration(input_axis, delta):
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta) 

func apply_friction(input_axis, delta):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis, delta):
	if input_axis == 0 and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)

func update_animations(input_axis):
	if input_axis:
		player_sprite.flip_h = (input_axis > 0)
		player_sprite.play("run")
	else:
		player_sprite.play("idle")
	
	if not is_on_floor():
		pass
#		print("play jump animation")


func header():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "Ball2":
			collision.get_collider().push_ball(Vector2(0, -200))




func _input(event):
	if event.is_action_pressed(input_data.attack):
		kick()

func _on_kick_hit_box_body_entered(body: CharacterBody2D):
	print(body)
	var kick_direction: Vector2 = direction_facing
	if direction_facing == Vector2.LEFT or direction_facing == Vector2.RIGHT:
		kick_direction += Vector2(0, -0.8)
	elif direction_facing == Vector2.DOWN:
		direction_facing = Vector2.UP
#	body.linear_velocity = Vector2.ZERO
	body.velocity = kick_direction * movement_data.kick_power
	

func check_direction_input():
	if Input.is_action_pressed(input_data.up):
#		print("up")
		direction_facing = Vector2.UP
	elif Input.is_action_pressed(input_data.down):
#		print("down")
		direction_facing = Vector2.DOWN
	elif Input.is_action_pressed(input_data.left):
#		print("left")
		direction_facing = Vector2.LEFT
	elif Input.is_action_pressed(input_data.right):
#		print("right")
		direction_facing = Vector2.RIGHT

func kick():
	check_direction_input()
	if can_kick == true:
		can_kick = false
		kick_hit_box.rotation = direction_facing.angle()
		kick_hit_box.monitoring = true
		if direction_facing == Vector2.DOWN:
			velocity.y = -movement_data.jump_velocity
		$KickHitBox/KickTimer.start()
		
func _on_timer_timeout():
	can_kick = true
	kick_hit_box.monitoring = false
