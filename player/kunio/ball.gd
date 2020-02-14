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
var move_right
var current_direction
# Called when the node enters the scene tree for the first time.
func _ready():
  set_use_custom_integrator(false)

#func fly():
#  apply_impulse(Vector2(), Vector2(100, 0))

func check_moving_and_direction():
  var dist = position - prev_pos
  moving = dist.x != 0 || dist.y != 0
  if dist.x > 0:
    current_direction = 1
  elif dist.x < 0:
    current_direction = -1

  prev_pos = position

func _process(_delta):
  $img.playing = moving
  if current_direction == -1:
    $img.flip_h = true
  elif current_direction == 1:
    $img.flip_h = false
  
  if not is_sticking && keeper:
    is_sticking = true
    set_use_custom_integrator(true)

  if is_sticking && keeper:
    var offset_x = current_direction*10
    position = keeper.position + Vector2(offset_x, 1)

func _physics_process(delta):
  check_moving_and_direction()

