extends CharacterBody2D


const SPEED: float = 100.0
const ACCELERATION: float = 800.0
const FRICTION: float = 1000.0
const JUMP_VELOCITY: float = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite_2d = $AnimatedSprite2D


func _physics_process(delta): # Ran everysingle physics frame (60 ticks per second, therefore called 60 times a second) - Delta: Time between each frame 
	apply_gravity(delta) # try commenting out gravity function to see what happens
	handle_jump()
	
	# Get the input direction and handle the movement/deceleration.
	var input_axis = Input.get_axis("ui_left", "ui_right") # Returns an int, ui_left --> return -1, ui_right --> return 1, returns 0 if we press neither or both
	handle_acceleration(input_axis, delta)
	apply_friction(input_axis, delta)
	update_animation(input_axis)
	
	
	# print(delta) - checking what delta doe
	move_and_slide()
	
	
func apply_gravity(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta # Apply fraction of gravity per tick, delta > 1, then velocity.y is increased to catchup on time gap
		
func handle_jump():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"): # Removing is_on_floor() enables endless jumping/flying
			velocity.y = JUMP_VELOCITY # Jump veloicty applied imm but 
	else: # In the air 
		if Input.is_action_just_released("ui_accept") and velocity.y < JUMP_VELOCITY / 2: # Check if not falling and SMALLER than (-200.0), JUMP_VELOCITY - Certain time window to release spacebar for short jump
			velocity.y = JUMP_VELOCITY / 2 # Short press on spacebar causes a smaller jump
			
func apply_friction(input_axis, delta):
	if input_axis == 0:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
func handle_acceleration(input_axis, delta):
	if input_axis != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_axis, ACCELERATION * delta)
		
func update_animation(input_axis):
	if input_axis != 0:
		animated_sprite_2d.flip_h = (input_axis < 0)
		animated_sprite_2d.play("run")
	else: 
		animated_sprite_2d.play("idle")
	
	if not is_on_floor(): 
		animated_sprite_2d.play("jump") # Order of jump is last and can override the previous animations
	
