extends Area2D

func _on_body_entered(body): # So when the Player (KinematicBody2D) collides with the heart it should disappear
	queue_free()
