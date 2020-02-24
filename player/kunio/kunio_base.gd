tool
extends Area2D

signal stopped

var timer = 0
var stop_time = 0.3
var stopping = false


var speed = 20
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(String, "horibata", "kunio", "yoritsune") var head = "kunio" setget set_head
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
export(Color, RGBA) var clothes_color = Color("#ffffff") setget update_clothes

# Called when the node enters the scene tree for the first time.
var kept_ball

export var is_selected = false setget set_selected

onready var ball = get_node("../ball")

func _input(event):
  if is_selected:
    if event is InputEventKey:
      #jump
      if event.is_action_pressed("jump") \
        and on_floor and is_selected:
        original_z = position.y
        jumping = true
        on_floor = false
        $shadow.visible = true

func _ready():
  set_process_input(true)
  add_to_group("players")
  material = material.duplicate()
  connect("area_entered", self, "meet")
  connect("stopped", self, "_get_ball")
  $fanim.connect("animation_finished", self, "passed" )

func set_selected(value):
  is_selected = value

func update_clothes(value):
  clothes_color = value
  material.set_shader_param("clothes", value)

func set_head(value):
  head = value
  $fanim.head = value

func _get_ball():
  kept_ball = ball
  kept_ball.keeper = self
  kept_ball.current_direction = 1 if $fanim.flip_h else -1

func meet(hit_by):
  if hit_by.name == "ball_shadow" && not kept_ball:
    var zhi = abs(ball.global_position.y - global_position.y)
    if zhi <= 25:
      # start getting ball
      if position.x > ball.position.x:
        $fanim.flip_h = true
      elif position.x < ball.position.x:
        $fanim.flip_h = false

      if ball.high_ball && abs(ball.height) >= 8:
        ball.linear_velocity.x = 0
        ball.moving = false
        stopping = true
      else:
        _get_ball()

func walk():
  $fanim.play("walk")

func run():
  $fanim.play("run")
  
func stop():
  $fanim.stop()
  $fanim.frame = 0

# TODO correct find nearest guy
func find_guy():
  var nearest_guy = null

  var guys = get_tree().get_nodes_in_group("players")
  for guy in guys:
    if guy.name != name:
      nearest_guy = guy
      break
  return nearest_guy

func pass_ball():
  if kept_ball:
    var nearest_guy = find_guy()
    if nearest_guy:
      passing = true
      var angle = position.direction_to(nearest_guy.position)
      var dist = position.distance_to(nearest_guy.position)
      dist -= 15 # center not good
      kept_ball.pass_ball(angle, dist)
      kept_ball = null
      
      is_selected = false
      nearest_guy.is_selected = true # simple active the other guy
      walking = false
      running = false

func jump(delta):
  var velo = Vector2()
  var curr_height = original_z - position.y
  var offset_y = delta * jump_force

  if falling:
    velo.y += offset_y
    if curr_height <= 0:
      velo.y = curr_height
      falling = false
      on_floor = true
  if jumping:
    velo.y -= offset_y*1.5
    if max_height <= curr_height:
      delta = -(max_height - curr_height)
      velo.y = -delta
      jumping = false
      falling = true

  return velo
  
var GRAVI = 8.0
var max_height = 25.0
var jump_force = 50.0

var original_z

var walking = false
var running = false
var falling = false
var jumping = false
var passing = false
var on_floor= true

func move(delta):
  var velocity = Vector2()
  if (is_selected || jumping || falling):
    var dist = speed*delta
    if Input.is_action_pressed('right'):
      velocity.x += dist
    if Input.is_action_pressed('left'):
      velocity.x -= dist
    if Input.is_action_pressed('down'):
      velocity.y += dist
      velocity.x = velocity.x * 0.87
    if Input.is_action_pressed('up'):
      velocity.y -= dist
      velocity.x = velocity.x * 0.87
    if jumping || falling:
      if velocity.y != 0:
        original_z += velocity.y
      var zj = jump(delta)
      velocity += zj
      $shadow.position.y -= zj.y
  return velocity

func _check_input_state():
  if is_selected:
    if Input.is_action_pressed("up") \
      or Input.is_action_pressed("down") \
      or Input.is_action_pressed("left") \
      or Input.is_action_pressed("right"):
      walking = true
    else:
      walking = false
    
    #flip
    if Input.is_action_pressed("left") and not $fanim.flip_h:
      $fanim.flip_h = true
    if Input.is_action_pressed("right") and $fanim.flip_h:
      $fanim.flip_h = false

func _update_animation():
  _check_input_state()

  if walking:
    $fanim.play("walk")
    return
  
  if passing:
    $fanim.play("pass")
    return
  
  if stopping:
    $fanim.play("stop")
    return

  $fanim.play("stand")

func passed():
  if $fanim.animation == "pass":
    passing = false

func _process(delta):  
  if stopping:
    timer += delta
    print(timer, stop_time)
    if timer > stop_time:
      stopping = false
      timer = 0
      emit_signal("stopped")

  if !(jumping || falling):
    $shadow.visible = false

  _update_animation()

func _physics_process(delta):
  var velo = move(delta)
  
  position += velo
  if kept_ball:
    if Input.is_action_pressed("shot"):
      pass_ball()

