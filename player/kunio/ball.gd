extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prev_pos = position
var flying = false
var keeper
var is_sticking = false

# (used when sticked) transform (tr) at the collistion instant (ci) from the
# collider to the ball

var moving
var current_direction = 1

var height = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  set_use_custom_integrator(false)

#func fly():
#  apply_impulse(Vector2(), Vector2(100, 0))

func update_moving_and_direction():
  var dist = position - prev_pos
  moving = dist.x != 0 || dist.y != 0
  
  if keeper:
    current_direction = -1 if keeper.get_node("fanim").flip_h else 1
  elif dist.x > 0:
    current_direction = 1
  elif dist.x < 0:
    current_direction = -1

  prev_pos = position

func _calculate_angle(angle):
  return Vector2()

func shoot(angle, distant):
  angular_velocity = 0.0
  is_sticking = false
  keeper = null

  mode = RigidBody2D.MODE_CHARACTER
  print(rad2deg(angle.angle()))
  if distant > 200:
    print('height ball')
    var high_angle = _calculate_angle(angle)
    
#    var high_angle = angle.rotated(deg2rad(45))
  var impulse = angle * distant
  apply_central_impulse(impulse)
  
func _process(_delta):
  $img.playing = moving
  if current_direction == -1:
    $img.flip_h = true
  elif current_direction == 1:
    $img.flip_h = false
  
  if not is_sticking && keeper:
    is_sticking = true
    mode = RigidBody2D.MODE_STATIC

  if is_sticking && keeper:
    var offset_x = current_direction*10
    position = keeper.position + Vector2(offset_x, 1)
  
  if height > 0:
    $shadow.position.y = position.y - height
  
export(float) var deceleration

var cele = 0
func _slow_down(state, deceleration):
  var speed = state.linear_velocity.length()
  
  cele += deceleration/5
  if cele > deceleration:
    cele = deceleration
    
  speed -= cele * state.step
  if speed < 0:
    cele = 0
    speed = 0
  
  state.linear_velocity = state.linear_velocity.normalized() * speed

func _physics_process(delta):
  update_moving_and_direction()

func _integrate_forces(state):
  _slow_down(state, deceleration)

