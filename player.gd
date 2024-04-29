extends CharacterBody2D

@export var movement_data : PlayerMovementData # variable called movement_data of type PlayerMovementData (gd script which inherits resource)
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer

func _physics_process(delta): # Ran everysingle physics frame (60 ticks per second, therefore called 60 times a second) - Delta: Time between each frame 
	apply_gravity(delta) # try commenting out gravity function to see what happens
	handle_jump()
	
	# Get the input direction and handle the movement/deceleration.
	var input_axis = Input.get_axis("ui_left", "ui_right") # Returns an int, ui_left --> return -1, ui_right --> return 1, returns 0 if we press neither or both
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	apply_air_resistance(input_axis, delta)
	update_animation(input_axis)
	
	var was_on_floor = is_on_floor() # Check if player was on floor before moving 
	
	
	# print(delta) - checking what delta doe
	move_and_slide()
	
	var just_left_ledge = was_on_floor and not is_on_floor() and velocity.y >= 0 # Before moving: on floor?, After moving: in air/! on_floor, Is player in falling state?
	if just_left_ledge:
		coyote_jump_timer.start()
	if Input.is_action_just_pressed("ui_accept"):
		movement_data = load("res://FasterMovementData.tres") # Switches from SlowerMovementData resource to the FasterMovementData
		
	
	
func apply_gravity(delta : float):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity *  movement_data.gravity_scale * delta # Apply fraction of gravity per tick, delta > 1, then velocity.y is increased to catchup on time gap
		
func handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0: # Checks if on floor or coyote jump window is still open, then allow player to jump
		if Input.is_action_just_pressed("ui_accept"): # Removing is_on_floor() enables endless jumping/flying
			velocity.y = movement_data.jump_velocity # Jump veloicty applied imm but 
	if not is_on_floor(): # In the air 
		if Input.is_action_just_released("ui_accept") and velocity.y < movement_data.jump_velocity / 2: # Check if not falling and SMALLER than (-200.0), JUMP_VELOCITY - Certain time window to release spacebar for short jump
			velocity.y = movement_data.jump_velocity / 2 # Short press on spacebar causes a smaller jump
			
func apply_friction(input_axis : float, delta : float):
	if input_axis == 0 and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)

func apply_air_resistance(input_axis : float, delta : float):
	if input_axis == 0 and not is_on_floor():
		velocity.x - move_toward(velocity.x, 0, movement_data.air_resistance * delta)
	
func handle_acceleration(input_axis : float, delta : float):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, movement_data.speed * input_axis, movement_data.acceleration * delta)
		
func update_animation(input_axis : float):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else: 
		animated_sprite_2d.play("idle")
	
	if not is_on_floor(): 
		animated_sprite_2d.play("jump") # Order of jump is last and can override the previous animations
	
