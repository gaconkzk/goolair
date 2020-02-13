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
#  self.connect("area_entered", self, "hithithit")
  self.connect("body_entered", self, "meet")

func meet(hit_by):
  if (hit_by.name == "ball"):
    kept_ball = hit_by
    

func flip():
  if Input.is_action_pressed("ui_left") and not $fanim.flip_h:
    $fanim.flip_h = true
    kept_ball_dir = -1
    
  if Input.is_action_pressed("ui_right") and $fanim.flip_h:
    $fanim.flip_h = false
    kept_ball_dir = 1

func walk():
  $fanim.play("walk")

func run():
  $fanim.play("run")

func stop():
  $fanim.stop()
  $fanim.frame = 0

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
    var new_pos = position
    new_pos.x += 10*kept_ball_dir
    new_pos.y += 1
    kept_ball.position = new_pos
