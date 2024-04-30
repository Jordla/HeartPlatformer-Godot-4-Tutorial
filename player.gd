extends CharacterBody2D

@export var movement_data : PlayerMovementData # variable called movement_data of type PlayerMovementData (gd script which inherits resource)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var air_jump: bool = false
var just_wall_jumped: bool = false

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var starting_position = global_position # Attribute of the 2DNode and only available when the node is ready 

func _physics_process(delta): # Ran everysingle physics frame (60 ticks per second, therefore called 60 times a second) - Delta: Time between each frame 
	apply_gravity(delta) # Try commenting out gravity function to see what happens
	handle_wall_jump()
	handle_jump()
	var input_axis = Input.get_axis("ui_left", "ui_right") # Returns an int, ui_left --> return -1, ui_right --> return 1, returns 0 if we press neither or both
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	handle_air_acceleration(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animation(input_axis)
	var was_on_floor = is_on_floor() # Check if player was on floor before moving 
	# print(delta) - checking what delta does
	move_and_slide()
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0 # Before moving: on floor?, After moving: in air/! on_floor, Is player in falling state?
	if just_left_ledge:
		coyote_jump_timer.start()
	if Input.is_action_just_pressed("ui_accept"):
		movement_data = load("res://FasterMovementData.tres") # Switches from SlowerMovementData resource to the FasterMovementData
	just_wall_jumped = false


func apply_gravity(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity *  movement_data.gravity_scale * delta # Apply fraction of gravity per tick, delta > 1, then velocity.y is increased to catchup on time gap

func handle_wall_jump():
	if not is_on_wall_only(): return # New function in Godot 4
	var wall_normal = get_wall_normal() # Detects if collided with wall and returns a normal (orthogonal vector pointing away from wall) - vector2D
	if Input.is_action_just_pressed("ui_accept"):
		velocity.x = wall_normal.x * movement_data.speed # Horizontal velocity is need to "push" off the wall in the opposite direction
		velocity.y = movement_data.jump_velocity # A jump
		just_wall_jumped = true


func handle_jump():
	if is_on_floor(): air_jump = true
	
	if is_on_floor() or coyote_jump_timer.time_left > 0.0: # Checks if on floor or coyote jump window is still open, then allow player to jump
		if Input.is_action_just_pressed("ui_accept"): # Removing is_on_floor() enables endless jumping/flying
			velocity.y = movement_data.jump_velocity # Jump veloicty applied imm but 
	elif not is_on_floor(): # In the air 
		if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_velocity / 2: # Check if not falling and SMALLER than (-200.0), JUMP_VELOCITY - Certain time window to release spacebar for short jump
			velocity.y = movement_data.jump_velocity / 2 # Short press on spacebar causes a smaller jump
		
		if Input.is_action_just_pressed("ui_accept") and air_jump == true and not just_wall_jumped: # In the air and has an air_jump available and hasn't wall jumped recently 
			velocity.y = movement_data.jump_velocity * 0.8 # Make the air jump less powerful than the regular jump
			air_jump = false

func handle_acceleration(input_axis : float, delta : float): # Ground acceleration
	if not is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)

func apply_friction(input_axis : float, delta : float):
	if input_axis == 0 and is_on_floor(): # Not moving and on the ground
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func handle_air_acceleration(input_axis : float, delta : float): # Air acceleration
	if is_on_floor(): return
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.air_acceleration * delta)

func apply_air_resistance(input_axis : float, delta : float):
	if input_axis == 0 and not is_on_floor(): # Not moving and in the air
		velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)
	

func update_animation(input_axis : float):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else: 
		animated_sprite_2d.play("idle")
	
	if not is_on_floor(): 
		animated_sprite_2d.play("jump") # Jump animation can be executed last which overrides the previous animations
	


func _on_hazard_detector_area_entered(area):
	global_position = starting_position # Also enabled position smoothing in the Camera2D node - Makes the game blurry though
	# queue_free() # Destroys/deletes node that script is attached to and all subsequent children 
