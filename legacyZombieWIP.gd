extends KinematicBody

# state wander
# when enter area placed at intersections choose random direction

# state chase(slow and fast)
# when area around entered move towards but still slow
# when raycast(at least one of three) entered turn and chase player
# icon on map changed to red

const SPEED = 2.0

var target = null
var vel = Vector3()
var path = null
var path_finder = null

#onready var hitbox = $HitboxArea

func _ready():
	self.set_physics_process(false)
#	hitbox.connect("body_entered", self, "on_hit_player")
	path_finder = PathFinder.new(get_parent(), 0) # gets parent which is the gridmap, and the index of the walkable area
	print(path_finder.indicies)
	var timer = Timer.new()
	timer.wait_time = 1
	add_child(timer)
	timer.connect("timeout", self, "find_path_timer")
	timer.start()

# warning-ignore:unused_argument
func _physics_process(delta):
	self.look_at(target.global_transform.origin, Vector3.UP)
	
	if path.size() > 0:
		move_along_path(path)

# warning-ignore:shadowed_variable
func move_along_path(path):
	if global_transform.origin.distance_to(path[0]) < 0.1:
		path.remove(0)
		if path.size() == 0:
			return
	vel = (path[0] - global_transform.origin).normalized() * SPEED
	vel = move_and_slide(vel)

# warning-ignore:shadowed_variable
func set_target(target):
	self.target = target
	self.set_physics_process(true)
	find_path_timer()

func find_path_timer():
	path = path_finder.find_path(global_transform.origin, target.global_transform.origin)
	path.remove(0)
