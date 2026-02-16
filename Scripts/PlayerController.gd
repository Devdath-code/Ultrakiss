extends CharacterBody2D
@export var SPEED = 600.0
@export_range(0,1) var acceleration =0.1
@export var JUMP_VELOCITY = -400.0
@export var WALLJUMP_VEL = -300.0
@export_range(0,1) var deceleration = 0.1
var can_wall_jump = true
var last_wall_normal = 0
var wall_jump_locked := false
var wall_jump_count := 0
const MAX_WALL_JUMPS := 2
@export var dash_speed = 1000.0
@export var dash_max_distance = 300.0
@export var dash_curve: Curve
@export var dash_cooldown = 1.0
var is_dashing = false
var dash_start_position = 0
var dash_direction = 0
var dash_timer = 0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Player_jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			wall_jump_count = 0   # reset when grounded
		elif is_on_wall() and wall_jump_count < MAX_WALL_JUMPS:
			var wall_dir = get_wall_normal().x
			velocity.y = JUMP_VELOCITY
			velocity.x += wall_dir * WALLJUMP_VEL
			velocity += get_wall_normal() * 20  # detach push  
			wall_jump_count += 1

			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Player_left", "player_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acceleration)
		animated_sprite.play("run")
		if direction < 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * deceleration)
		animated_sprite.play("idle")
	# Reset wall jump if we touch a new wall
# Reset lock when we leave the wall
	if is_on_floor():
		wall_jump_count = 0
		
	if Input.is_action_just_pressed("Player_dash") and direction and not is_dashing and dash_timer <= 0:
		is_dashing = true
		dash_start_position = position.x
		dash_direction = direction
		dash_timer = dash_cooldown
		
	
	if is_dashing:
		var current_distance = abs(position.x - dash_start_position)
		if current_distance >= dash_max_distance or is_on_wall():
			is_dashing = false
		else:
			velocity.x = dash_direction * dash_speed * dash_curve.sample(current_distance/dash_max_distance)
			velocity.y = 0
			
	if dash_timer > 0:
		dash_timer -= delta
		
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
		
	move_and_slide()
