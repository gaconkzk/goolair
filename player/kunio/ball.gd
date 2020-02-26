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
  gravity_scale = 0
  z_as_relative = true
  z_index = 2
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
  var tg = tan(deg2rad(angle))
  var b = 2* tg
  var a = - 2 * tg / distant
  
  var h = x * (a * x + b)
  
  return h

var spd = 70

func pass_ball(angle, d):
  linear_velocity = Vector2()
  is_sticking = false
  keeper = null

  mode = RigidBody2D.MODE_CHARACTER

  distant = d
  ori_pos = position
  high_ball = true
  shadow.show = true
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
    shadow.show = false
    
    mode = RigidBody2D.MODE_STATIC
  
  if keeper:
    height = keeper.height
    if keeper.height != 0 && not shadow.show:
      shadow.show = true
    if keeper.height == 0 && shadow.show:
      shadow.show = false

  var pos = global_position
  shadow.global_position = pos
  if height > 0:
    shadow.position.y += height
  elif height < 0:
    shadow.position.y -= height
  
  if height != 0:
    z_index = 800

func _physics_process(delta):
  update_moving_and_direction()
  
  if is_sticking && keeper:
    var offset_x = current_direction*10
    position = keeper.position + Vector2(offset_x, 0)

func _integrate_forces(state):
#  _slow_down(state)

  if high_ball:
    var current_x = position.x - ori_pos.x
    
    # well bouncing Errrrrrrrr
    if abs(current_x) >= distant:
      $hit_ground.play()
      high_ball = false
      height = 0
      shadow.show = false
    else:
      var si = sign(current_x)
      var angle = 35 if si > 0 else -135
      
      height = _calculate_height(current_x, si * distant, angle)
      position.y += -height*si
