extends Node2D

@export var next_level : PackedScene # Type PackedScene?
# Static body (This is like a container) 
	# CollisionPolygon2D is the collision hitbox 
	# Polygon2D is the actual shape being displayed to screen when the scene runs
# @onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
# @onready var polygon_2d = $StaticBody2D/Polygon2D # Control drag shortcut
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer


func _ready(): 
	get_tree().paused = true
	LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	# level_completed.hide()
	# polygon_2d.polygon = collision_polygon_2d.polygon # Set the empty list of polygons to be the list of polygon from the collison node
	Events.level_completed.connect(show_level_completed) # Don't put show_level_completed() as we don't want to call the func only connect it
	
	
	
func show_level_completed():
	level_completed.show()
	get_tree().paused = true # Upon level completion pause the game
	await get_tree().create_timer(0.5, 1).timeout # Wait for 1 second timer to be created and then timeout before executing next line of code
	if not next_level is PackedScene: return # Exit clause, What is not next_level? (!PackedScene)?, Exits if PackedScene returns null
	await LevelTransition.fade_to_black() # await here is waiting for function to finish, await in the function is waiting for animation to finish
	get_tree().paused = false	# Unpause
	get_tree().change_scene_to_packed(next_level) # How does it know what the next PackedScene is?
	

	
	



