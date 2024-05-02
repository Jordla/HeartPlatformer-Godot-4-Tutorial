extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_from_black():
	animation_player.play("fade_from_black")
	await animation_player.animation_finished # await keyword, waits for animation to finish then continues to execute code
	
func fade_to_black():
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
