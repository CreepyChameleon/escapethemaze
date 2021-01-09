extends Spatial

onready var objectiveList = [
	$Objective/Area
]

func _ready():
	var viewport = $Viewport
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	$ViewportDisplay.material_override.albedo_texture = viewport.get_texture()

func _process(_delta):
	$Viewport/Map.set_playerArrow_pos(Vector2(($playerNew.global_transform.origin.x * 5) + 256, ($playerNew.global_transform.origin.z * 5) + 150))
