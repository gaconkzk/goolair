extends RigidBody
class_name BallMath25D

var vertical_speed := 0.0
var isometric_controls := true
var _parent_node25d: Node25D

func _ready():
  _parent_node25d = get_parent()


func _process(delta):
  if Input.is_action_just_pressed("ViewCubeDemo"):
    #warning-ignore:return_value_discarded
    get_tree().change_scene("res://assets/cube/Cube.tscn")
    return
  
  if Input.is_action_just_pressed("ToggleIsometricControls"):
    isometric_controls = !isometric_controls
  if Input.is_action_just_pressed("ResetPosition"):
    transform = Transform(Basis(), Vector3.UP * 10)
    vertical_speed = 0
  else:
    _horizontal_movement(delta)
    _vertical_movement(delta)


# Checks WASD and Shift for horizontal movement via move_and_slide.
func _horizontal_movement(delta):
  var localX = Vector3.RIGHT
  var localZ = Vector3.BACK
  
  # TODO: Replace with is_equal_approx() in Godot 3.2.
  if (isometric_controls && abs(Node25D.SCALE * 0.86602540378 - _parent_node25d.get_basis()[0].x) < 0.000001):
    localX = Vector3(0.70710678118, 0, -0.70710678118)
    localZ = Vector3(0.70710678118, 0, 0.70710678118)
  
  # Gather player input and add directional movement to a Vector3 variable.
  var move_dir = Vector3()
  move_dir += localX * (Input.get_action_strength("right") - Input.get_action_strength("left"))
  move_dir += localZ * (Input.get_action_strength("MoveBackward") - Input.get_action_strength("MoveForward"))
  
  move_dir = move_dir.normalized() * delta * 600;
  if Input.is_action_pressed("MovementModifier"):
    move_dir /= 2;
  
  #warning-ignore:return_value_discarded
  apply_central_impulse(move_dir)


# Checks Jump and applies gravity and vertical speed via move_and_collide.
func _vertical_movement(delta):
  var localY = Vector3.UP
  if Input.is_action_just_pressed("Jump"):
    vertical_speed = 1.25
  vertical_speed -= delta * 5 # Gravity
  var k = apply_central_impulse(localY * vertical_speed);
  if k != null:
    vertical_speed = 0
