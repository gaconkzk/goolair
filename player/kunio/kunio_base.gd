tool
extends Area2D

var speed = 30
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

func _ready():
  add_to_group("players")
  material = material.duplicate()
  self.connect("body_entered", self, "meet")

func set_selected(value):
  is_selected = value

func update_clothes(value):
  clothes_color = value
  material.set_shader_param("clothes", value)

func set_head(value):
  head = value
  $fanim.head = value

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
    var guys = get_tree().get_nodes_in_group("players")
    var nearest_guy
    for guy in guys:
      if guy.name != name:
        nearest_guy = guy
        break
#    for guy in guys:
#      if guy.global_position.distance_to(position.global_position) < nearest_guy.global
    
    if nearest_guy:
#      var vec_angle = (nearest_guy.global_position - global_position).normalized()
      var angle = position.angle_to_point(nearest_guy.position)
  #    var angle = deg2rad(45.0)
      var vec_angle = Vector2(-cos(angle), -sin(angle))
      kept_ball.reset()
      kept_ball.apply_central_impulse(vec_angle*100)
      kept_ball.is_sticking = false
      kept_ball.keeper = null
      kept_ball.set_use_custom_integrator(false)
      kept_ball = null
      
      is_selected = false
      nearest_guy.is_selected = true
    

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
