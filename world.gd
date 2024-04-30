extends Node2D


# Static body (This is like a container) 
	# CollisionPolygon2D is the collision hitbox 
	# Polygon2D is the actual shape being displayed to screen when the scene runs
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/Polygon2D # Control drag shortcut
@onready var level_completed = $CanvasLayer/LevelCompleted

func _ready(): 
	level_completed.hide()
	RenderingServer.set_default_clear_color(Color.BLACK)
	polygon_2d.polygon = collision_polygon_2d.polygon # Set the empty list of polygons to be the list of polygon from the collison node
	Events.level_completed.connect(show_level_completed) # Don't put show_level_completed() as we don't want to call the func only connect it
	
func show_level_completed():
	level_completed.show()
	get_tree().paused = true # Upon level completion pause the game
	
	
