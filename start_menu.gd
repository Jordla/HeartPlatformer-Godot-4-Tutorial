extends CenterContainer
@onready var start_game_button = %StartGameButton
@onready var quit_button = %QuitButton

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK) # Moved from World node to startmenu 
	start_game_button.grab_focus() # Sets the focus to the StartButton, can now navigate menu using arrow keys

func _on_start_game_button_pressed():
	await LevelTransition.fade_to_black()
	get_tree().change_scene_to_file("res://level_one.tscn")
	LevelTransition.fade_from_black()
	

func _on_quit_button_pressed():
	get_tree().quit()
