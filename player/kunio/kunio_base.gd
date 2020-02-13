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
    kept_ball.get_parent().remove_child(kept_ball)
    add_child(kept_ball)
    kept_ball.owner = self
    kept_ball.set_physics_process(false)
    kept_ball.rolling = true
    kept_ball.position = Vector2(11, 0)*kept_ball_dir

func flip():
  if Input.is_action_pressed("ui_left") and not $fanim.flip_h:
    $fanim.flip_h = true
    kept_ball_dir = -1
    if kept_ball:
      kept_ball.position = Vector2(11, 0)*kept_ball_dir
    
  if Input.is_action_pressed("ui_right") and $fanim.flip_h:
    $fanim.flip_h = false
    kept_ball_dir = 1
    if kept_ball:
      kept_ball.position = Vector2(10, 0)*kept_ball_dir

func walk():
  $fanim.play("walk")
  if kept_ball:
    kept_ball.rolling = true

func run():
  $fanim.play("run")
  if kept_ball:
    kept_ball.rolling = true

func stop():
  $fanim.stop()
  $fanim.frame = 0
  if kept_ball:
    kept_ball.rolling = false
  
func shoot():
  if kept_ball:
    self.remove_child(kept_ball)
    get_parent().add_child(kept_ball)
    kept_ball.position += position
    kept_ball.set_physics_process(true)
    kept_ball.owner = get_parent()
    
    kept_ball.fly()
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
#  if kept_ball:
#    var new_pos = position
#    new_pos.x += 10*kept_ball_dir
#    new_pos.y += 1
#    kept_ball.position = new_pos
