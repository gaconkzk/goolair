extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prev_pos = position
var flying = false
var keeper
var is_sticking = false

onready var shadow = get_node("../ball_shadow")

onready var viewport = get_viewport()

# (used when sticked) transform (tr) at the collistion instant (ci) from the
# collider to the ball

var moving
var current_direction = 1

var high_ball = false
var height = 0
var ori_pos
var distant = 0

# Called when the node enters the scene tree for the first time.
func _ready():
  set_use_custom_integrator(false)
  shadow.global_position = global_position

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

func _calculate_height(x, distant, angle):
  # math hahahaha
  # ===================
  # distant = d
  # x = 0, h = 0   - 1
  # x = d, h = 0   - 2
  # x = d/2, h = tg(angle) * d/2 = D // max_height
  # h = x(ax + b)
  # 0 = ax + b = ad +b
  # D = ad/2 + b = ad + 2b
  # => b = D
  # a = -D/d
  # h = -Dx(x/d + 1) = -d*tg(angle)*x* 2(x/d + 1) = x * (-tg(angle) * x / 2  + tg(angle) * d / 2)
  # 45o (tg(angle) = 1): x * (-x/2 + d/2)
  var tg = tan(deg2rad(angle))
  var max_height = (tg * distant) / 2
  
  var height = x * ((-tg * x / 2) + max_height) / 10
  
  return height

var spd = 70

func pass_ball(angle, d):
  angular_velocity = 0.0
  is_sticking = false
  keeper = null

  mode = RigidBody2D.MODE_CHARACTER

  distant = d
  ori_pos = position
  high_ball = true
  shadow.visible = true

  var impulse = angle * spd
  apply_central_impulse(impulse)
  
func _process(_delta):
  $img.playing = moving
  if current_direction == -1:
    $img.flip_h = true
  elif current_direction == 1:
    $img.flip_h = false
  
  if not is_sticking && keeper:
    high_ball = false
    is_sticking = true
    
    # reset positions
    shadow.visible = false
    height = 0
    
    mode = RigidBody2D.MODE_STATIC

  if is_sticking && keeper:
    var offset_x = current_direction*10
    position = keeper.position + Vector2(offset_x, 1)
#
  var pos = global_position
  shadow.global_position = pos
  if height > 0:
    shadow.position.y += height
  elif height < 0:
    shadow.position.y -= height
#  else:
#    shadow.position.y = pos

#var cele = 0
#func _slow_down(state):
#  var force = state.linear_velocity.length()
#  state.linear_velocity = state.linear_velocity.normalized() * force
#  if state.linear_velocity.x < 1 and state.linear_velocity.x > -1:
#    state.linear_velocity.x = 0
#  if state.linear_velocity.y < 1 and state.linear_velocity.y > -1:
#    state.linear_velocity.y = 0

func _physics_process(delta):
  update_moving_and_direction()

func _integrate_forces(state):
#  _slow_down(state)

  if high_ball:
    print($collide.position)
    var current_x = position.x - ori_pos.x
    
    # well bouncing Errrrrrrrr
    if abs(current_x) >= distant+20:
      high_ball = false
      height = 0
      shadow.visible = false
    else:
      var si = sign(current_x)
      var angle = 15 if si > 0 else 165
      
      height = _calculate_height(current_x, si * distant, angle)
      position.y += -height*si
