extends Node2D


# Static body (This is like a container) 
	# CollisionPolygon2D is the collision hitbox 
	# Polygon2D is the actual shape being displayed to screen when the scene runs
@onready var collision_polygon_2d = $StaticBody2D/CollisionPolygon2D
@onready var polygon_2d = $StaticBody2D/Polygon2D # Control drag shortcut

func _ready(): 
	polygon_2d.polygon = collision_polygon_2d.polygon # Set the empty list of polygons to be the list of polygon from the collison node
