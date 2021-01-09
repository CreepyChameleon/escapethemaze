extends KinematicBody

const GRAVITY = -24.8
var vel = Vector3()
var MAX_SPEED = 7
const JUMP_SPEED = 18
const ACCEL = 4.5
var sprint = 1
var flashlight = true
var lookAtObj = false
var objectiveBody : Object

var dir = Vector3()
var camDir = 3
onready var counter = 0

var currAnim

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var camera
var rotation_helper
var raycast

var MOUSE_SENSITIVITY = 0.1

func _ready():
	camera = $RotationHelper/Camera
	rotation_helper = $RotationHelper
	raycast = $RotationHelper/RayCast
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	process_input(delta)
	process_movement(delta)

# warning-ignore:unused_argument
func process_input(delta):
# ----------------------------------
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
# ----------------------------------
	var pressed = false
	var input_movement_vector = Vector2()
	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
		pressed = true
	if Input.is_action_pressed("move_back"):
		input_movement_vector.y -= 1
		pressed = true
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
		pressed = true
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1
		pressed = true
	# sprint functionality
	if Input.is_action_just_pressed("sprint"):
		sprint = 2
	elif Input.is_action_just_released("sprint"):
		sprint = 1
	# flashlight toggle
	if Input.is_action_just_pressed("toggle_light"):
		flashlight = !flashlight
	if flashlight:
		$RotationHelper/Flashlight.light_energy = 20
		MAX_SPEED = 7
	elif !flashlight:
		$RotationHelper/Flashlight.light_energy = 0
		MAX_SPEED = 8
	if Input.is_action_just_pressed("collect_objective") and lookAtObj:
		objectiveBody.queue_free()
# ----------------------------------
	#################
	# State Machine #
	#################
	if pressed and Input.is_action_pressed("sprint"):
		if currAnim == "idle":
			$AnimationPlayer.set_blend_time("idle", "running", .3)
		elif currAnim == "walkCrouched":
			$AnimationPlayer.set_blend_time("walkCrouched", "running", .3)
		else:
			$AnimationPlayer.play("running")
#			$AudioStreamPlayer3D.playing = true
#			$AudioStreamPlayer3D.stream = load("res://sounds/player/zapsplat_footstep_low.wav")
#			$AudioStreamPlayer3D.play()
		currAnim = "running"
		if abs($RotationHelper.rotation_degrees.x) < 27:
			$headBob.play("bobFast")
	elif pressed and !Input.is_action_pressed("sprint"):
		if currAnim == "idle":
			$AnimationPlayer.set_blend_time("idle", "walkCrouched", .3)
		elif currAnim == "running":
			$AnimationPlayer.set_blend_time("running", "walkCrouched", .3)
		else:
			$AnimationPlayer.play("walkCrouched")
		currAnim = "walkCrouched"
		if abs($RotationHelper.rotation_degrees.x) < 27:
			$headBob.play("bobSlow")
	else:
		if currAnim == "running":
			$AnimationPlayer.set_blend_time("running", "idle", .3)
		elif currAnim == "walkCrouched":
			$AnimationPlayer.set_blend_time("walkCrouched", "idle", .3)
		else:
			$AnimationPlayer.play("idle")
		currAnim = "idle"
# ----------------------------------
	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x
# ----------------------------------
	# Capturing/Freeing the cursor
#	if Input.is_action_just_pressed("ui_cancel"):
#		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
#			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
#		else:
#			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
## ----------------------------------

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY
	
	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED * sprint
	
	var accel
	if is_on_floor():
		if dir.dot(hvel) > 0:
			accel = ACCEL
		else:
			accel = DEACCEL
	else:
		accel = 2 # decreased movement while in the air(air friction)

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

func _process(_delta):
# ---------------------------------- check if looking at objective
	if raycast.is_colliding():
		if raycast.get_collider() in self.owner.objectiveList:
			objectiveBody = raycast.get_collider().get_parent()
			lookAtObj = true
		else:
			lookAtObj = false
	else:
		lookAtObj = false
# ---------------------------------- if looking at objective render tip
	if lookAtObj:
		$lookObjText.visible = true
	else:
		$lookObjText.visible = false

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
