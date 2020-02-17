tool
extends Area2D

var speed = 30
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var kept_ball

export var is_selected = true

func _ready():
  self.connect("body_entered", self, "meet")

func meet(hit_by):
  if hit_by.name == "ball" && not kept_ball:
    kept_ball = hit_by
    kept_ball.keeper = self
    kept_ball.current_direction = 1 if $fanim.flip_h else -1
    kept_ball.set_use_custom_integrator(true)

func flip():
  if Input.is_action_pressed("left") and not $fanim.flip_h:
    $fanim.flip_h = true
    
  if Input.is_action_pressed("right") and $fanim.flip_h:
    $fanim.flip_h = false
    
func walk():
  $fanim.play("walk")

func run():
  $fanim.play("run")
  
func stop():
  $fanim.stop()
  $fanim.frame = 0
  
func shoot():
  if kept_ball:
    # TODO find nearest guy
    var vec_angle = (get_parent().get_node("guest").position - position).normalized()
#    var angle = deg2rad(45.0)
#    var vec_angle = Vector2(cos(angle), -sin(angle))
    kept_ball.apply_central_impulse(vec_angle*100)
    kept_ball.is_sticking = false
    kept_ball.keeper = null
    kept_ball = null

func move(delta):
  var velocity = Vector2()
  var dist = speed*delta
  if (is_selected):
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
  return velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var action_pressed = is_selected && (Input.is_action_pressed("right") || Input.is_action_pressed("left") || Input.is_action_pressed("down") || Input.is_action_pressed("up"))
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
