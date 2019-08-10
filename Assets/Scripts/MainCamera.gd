extends Camera

export var mouselook = true
export (float, 0.0, 1.0) var sensitivity = 0.5
export (float, 0.0, 0.999, 0.001) var smoothness = 0.5
export(NodePath) var pivot #setget set_privot
export (int, 0, 360) var yaw_limit = 360
export (int, 0, 360) var pitch_limit = 360

var _mouse_position = Vector2(0.0, 0.0)
var _yaw = 0.0
var _pitch = 0.0
var _total_yaw = 0.0
var _total_pitch = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pivot = get_parent().get_node("Table")
	
func _process(delta):
	if(Input.is_action_pressed("rotate_camera")):
		_update_mouselook()
		get_parent().get_node("Players/Player/Hand")._ready()

func _input(event):
	if event is InputEventMouseMotion:
		_mouse_position = event.relative

func _update_mouselook():
	_mouse_position *= sensitivity
	_yaw = _yaw * smoothness + _mouse_position.x * (1.0 - smoothness)
	_pitch = _pitch * smoothness + _mouse_position.y * (1.0 - smoothness)
	_mouse_position = Vector2(0, 0)

	if yaw_limit < 360:
		_yaw = clamp(_yaw, -yaw_limit - _total_yaw, yaw_limit - _total_yaw)
	if pitch_limit < 360:
		_pitch = clamp(_pitch, -pitch_limit - _total_pitch, pitch_limit - _total_pitch)

	_total_yaw += _yaw
	_total_pitch += _pitch

	if pivot:
		var target = pivot.get_translation()
		var offset = get_translation().distance_to(target)

		set_translation(target)
		rotate_y(deg2rad(-_yaw))
		rotate_object_local(Vector3(1,0,0), deg2rad(-_pitch))
		translate(Vector3(0.0, 0.0, offset))

