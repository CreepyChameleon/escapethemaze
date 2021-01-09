extends Control

onready var zombie = get_parent().get_parent().get_node("Navigation/zombie")
onready var scene = get_parent().get_parent()

func _ready():
	$DebugMenu/HBoxContainer/enemyToggle.pressed = zombie.enabled
	$DebugMenu/HBoxContainer2/darkToggle.pressed = scene.dark

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Menu_pressed():
	SceneChanger.scene_change("res://scenes/Menu/main_menu.tscn")


func _on_enemyToggle_pressed():
	zombie.enabled = not zombie.enabled
	$DebugMenu/HBoxContainer/enemyToggle.pressed = zombie.enabled


func _on_darkToggle_pressed():
	scene.dark = not scene.dark
	$DebugMenu/HBoxContainer2/darkToggle.pressed = scene.dark

func _on_enemyReset_pressed():
	scene.zombie.state = "wander"
	scene.get_target()
