extends KinematicBody

const SPEED = 2.0

var target = null
var vel = Vector3()
var path = null
var path_finder = null

#onready var hitbox = $HitboxArea

func _ready():
#	hitbox.connect("body_entered", self, "on_hit_player")
	path_finder = PathFinder.new(get_parent(), 0) # gets parent which is the gridmap, and the index of the walkable area
	
	var timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "find_path_timer")
	timer.start()

func _physics_process(delta):
	if target == null or path == null:
		return
	
	self.look_at(target.global_transform.origin, Vector3.UP)
	
	if path.size() > 0:
		move_along_path(path)

func get_path_to(target):
	pass

func move_along_path(path):
	if path.size() <= 0:
		return

func set_target(target):
	self.target = target

func find_path_timer():
	path = path_finder.find_path(global_transform.origin, target.global_transform.origin)
