extends Node2D

func _ready():
	get_tree().paused = false

func _on_Singleplayer_pressed():
	SceneChanger.scene_change("res://scenes/terrain/arena1.tscn")


func _on_Multiplayer_pressed():
	pass # Replace with function body.


func _on_Settings_pressed():
	SceneChanger.scene_change("res://scenes/Menu/settings.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Controls_pressed():
#	SceneChanger.scene_change("res://scenes/Menu/settings-controls.tscn")
	pass # not functioning


func _on_Menu_pressed():
	SceneChanger.scene_change("res://scenes/Menu/main_menu.tscn")
