extends Node2D

@export var next_level : PackedScene # Type PackedScene?


var level_time : float = 0.0
var start_level_msec : float = 0.0
# Static body (This is like a container) 
	# CollisionPolygon2D is the collision hitbox 
	# Polygon2D is the actual shape being displayed to screen when the scene runs
# @onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
# @onready var polygon_2d = $StaticBody2D/Polygon2D # Control drag shortcut
@onready var level_completed = $CanvasLayer/LevelCompleted
@onready var start_in = %StartIn
@onready var start_in_label = %StartInLabel
@onready var animation_player = $AnimationPlayer
@onready var level_time_label = %LevelTimeLabel


func _ready(): 
	Events.level_completed.connect(show_level_completed) # Don't put show_level_completed() as we don't want to call the func only connect it
	get_tree().paused = true
	# start_in.visible = true - Commented this code out because it's already visible by default
	await LevelTransition.fade_from_black()
	animation_player.play("countdown")
	await animation_player.animation_finished
	get_tree().paused = false
	start_in.visible = false
	start_level_msec = Time.get_ticks_msec() # Initial start time
	# print(start_level_msec)
	
func _process(delta):
	level_time = Time.get_ticks_msec() - start_level_msec # How long you've spent on the level
	level_time_label.text = str(level_time / 1000.0) # Gives us time in seconds
	
func go_to_next_level():
	if not next_level is PackedScene: return # Exit clause, What is not next_level? (!PackedScene)?, Exits if PackedScene returns null
	await LevelTransition.fade_to_black() # await here is waiting for function to finish, await in the function is waiting for animation to finish
	get_tree().paused = false	# Unpause
	get_tree().change_scene_to_packed(next_level) # How does it know what the next PackedScene is?
	
func show_level_completed():
	level_completed.show()
	level_completed.retry_button.grab_focus()
	get_tree().paused = true # Upon level completion pause the game

func _on_level_completed_next_level():
	pass # Replace with function body.


func _on_level_completed_retry():
	go_to_next_level()
