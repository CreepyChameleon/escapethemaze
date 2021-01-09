extends Node2D

onready var current_forward = $CanvasLayer/Keys/Forward/HBoxContainer2/Key
onready var current_backward = $CanvasLayer/Keys/Backward/HBoxContainer2/Key
onready var current_left = $CanvasLayer/Keys/Left/HBoxContainer2/Key
onready var current_right = $CanvasLayer/Keys/Right/HBoxContainer2/Key

var selecting_key = false
var previous_key
var new_key
var input_recieved = false

func _ready():
	pass # Replace with function body.


func _process(_delta):
	if !selecting_key:
		current_forward.text = InputMap.get_action_list("move_forward")[0].as_text()
		current_backward.text = InputMap.get_action_list("move_back")[0].as_text()
		current_left.text = InputMap.get_action_list("move_left")[0].as_text()
		current_right.text = InputMap.get_action_list("move_right")[0].as_text()

func _input(event):
	if selecting_key:
		new_key = event
		input_recieved = true

func new_input(bind):
	previous_key = InputMap.get_action_list(bind)[0]
	print(previous_key)
	selecting_key = true
	while !input_recieved:
		print(input_recieved)
		while selecting_key and input_recieved:
			print(previous_key)
			print(new_key)
			if previous_key != new_key and new_key != null:
				InputMap.action_erase_event(bind, previous_key)
				InputMap.action_add_event(bind, new_key)
				previous_key = new_key
				selecting_key = false
				input_recieved = false

func _on_ChangeF_pressed():
	print("changef")
	new_input("move_forward")
