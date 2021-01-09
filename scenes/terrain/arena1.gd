extends Spatial

var dark = true
onready var zombie = $Navigation/zombie
onready var player = $playerNew
onready var points = [
	$points/point1,
	$points/point2,
	$points/point3,
	$points/point4,
	$points/point5,
	$points/point6,
	$points/point7,
	$points/point8,
	$points/point9,
	$points/point10,
	$points/point11,
	$points/point12,
	$points/point13,
	$points/point14
]
onready var objectiveList = [
	
]

func _ready():
	if dark:
		$WorldEnvironment.environment.background_color = Color.black
		$Ceiling.visible = true
	else:
		$WorldEnvironment.environment.background_color = Color.white
		$Ceiling.visible = false
	var viewport = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	$ScreenCasing/ViewportDisplay.material_override.albedo_texture = viewport.get_texture()
	
	# set initial player position
#	player.global_transform.origin = points[randi() % points.size()].global_transform.origin
	
	zombie.state = "wander"
	get_target()

func get_target():
	if zombie.state == "wander":
		randomize()
		zombie.set_target(points[randi() % points.size()])
	if zombie.state == "chase":
		zombie.set_target(player)

func _process(_delta):
	if dark:
		$WorldEnvironment.environment.background_color = Color.black
		$Ceiling.visible = true
	else:
		$WorldEnvironment.environment.background_color = Color.white
		$Ceiling.visible = false
	$Viewport/Map.set_enemyCircle_pos(Vector2((zombie.global_transform.origin.x * 3.73) + 510, (zombie.global_transform.origin.z * 3.91) + 360))
	$Viewport/Map.set_playerArrow_pos(Vector2((player.global_transform.origin.x * 3.73) + 510, (player.global_transform.origin.z * 3.91) + 360))
	$Viewport/Map.set_playerArrow_rot((player.rotation_degrees.y + 180) * -1)
