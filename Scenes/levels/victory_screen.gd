extends CenterContainer

var winner_index = 0

@onready var play_again_button = %PlayAgainButton
@onready var main_menu_button = %MainMenuButton
@onready var winner_text = %WinnerText

func _ready():
	play_again_button.disabled = true
	main_menu_button.disabled = true
	winner_index = Events.winner_index
	
	if winner_index == 0:
		winner_text.text = "Player 1 Wins!!!"
	elif winner_index == 1:
		winner_text.text = "Player 2 Wins!!!"
	else:
		winner_text.text = "It's a Tie???"
	play_again_button.grab_focus()

func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/main_level.tscn")


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/levels/start_menu.tscn")


func _on_player_input_disable_timer_timeout():
	play_again_button.disabled = false
	main_menu_button.disabled = false
