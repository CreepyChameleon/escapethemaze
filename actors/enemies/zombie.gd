extends KinematicBody

var enabled = false
var path = []
var path_node = 0
var state : String

var speed = 10

var player
onready var nav = get_parent()

var counter = 0
var sweepDir = true

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	if enabled:
		if counter < 11:
			counter += delta
# ----------------------------------
		if state == "chase":
			$AnimationPlayer.play("crawling")
			speed = 10
			if counter >= 10:
				$AnimationPlayer.set_blend_time("crawling", "running", .3)
				state = "wander"
				self.owner.get_target()
			if $RayCast.get_collider() == self.owner.player:
				counter = 0
		if state == "wander":
			$AnimationPlayer.play("running")
			speed = 10
			if global_transform.origin.distance_to(player.global_transform.origin) < 2: # when reached point find new one
				self.owner.get_target()
			if $RayCast.get_collider() == self.owner.player: # finds player
				$AnimationPlayer.set_blend_time("running", "crawling", .3)
				state = "chase"
# ----------------------------------
		if sweepDir:
			if $RayCast.rotation_degrees.y >= 45:
				sweepDir = false
			else:
				$RayCast.rotation_degrees.y += 2
		if !sweepDir:
			if $RayCast.rotation_degrees.y <= -45:
				sweepDir = true
			else:
				$RayCast.rotation_degrees.y -= 2
# ----------------------------------
		if path_node < path.size():
			var direction = (path[path_node] - global_transform.origin)
			if direction.length() < 1:
				path_node += 1
			else:
				rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), delta * 4) # smooth turn to face(negate the directions if backwards)
#			look_at(global_transform.origin - direction, Vector3.UP)
# warning-ignore:return_value_discarded
				move_and_slide(direction.normalized() * speed, Vector3.UP)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 0
	
func _on_Timer_timeout():
	if state == "chase":
		self.owner.get_target()
	move_to(player.global_transform.origin)

func set_target(target):
	player = target
	set_physics_process(true)
