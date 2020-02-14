tool
extends Area2D

var speed = 30
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var kept_ball
var kept_ball_dir = 1

func _ready():
  self.connect("body_entered", self, "meet")
  kept_ball_dir = 1 if !$fanim.flip_h else -1

func meet(hit_by):
  if hit_by.name == "ball" && not kept_ball:
    kept_ball = hit_by
    kept_ball.keeper = self
    kept_ball.set_use_custom_integrator(true)

func flip():
  if Input.is_action_pressed("ui_left") and not $fanim.flip_h:
    $fanim.flip_h = true
    
  if Input.is_action_pressed("ui_right") and $fanim.flip_h:
    $fanim.flip_h = false
    
func walk():
  $fanim.play("walk")

func run():
  $fanim.play("run")
  
func stop():
  $fanim.stop()
  
func shoot():
  if kept_ball:
#    kept_ball.look_at(target)
    kept_ball.apply_impulse(Vector2(50, 35), Vector2(150, 2))
    kept_ball.is_sticking = false
    kept_ball.keeper = null
    kept_ball = null

func move(delta):
  var velocity = Vector2()
  var dist = speed*delta
  if Input.is_action_pressed('ui_right'):
      velocity.x += dist
  if Input.is_action_pressed('ui_left'):
      velocity.x -= dist
  if Input.is_action_pressed('ui_down'):
      velocity.y += dist
      velocity.x = velocity.x * 0.87
  if Input.is_action_pressed('ui_up'):
      velocity.y -= dist
      velocity.x = velocity.x * 0.87
  return velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var action_pressed = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
  if action_pressed:
    flip()
    walk()
  else:
    stop()

func _physics_process(delta):
  var velo = move(delta)
  position += velo
  if kept_ball:
    if Input.is_action_pressed("shot"):
      shoot()
