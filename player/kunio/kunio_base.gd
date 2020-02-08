tool
extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

func _ready():
  pass

func flip():
  if Input.is_action_pressed("ui_left"):
    $fanim.flip_h = true
  if Input.is_action_pressed("ui_right"):
    $fanim.flip_h = false

func walk():
  $fanim.play("walk")

func run():
  $fanim.play("run")

func stop():
  $fanim.stop()
  $fanim.frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var action_pressed = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
  if action_pressed:
    flip()
    walk()
  else:
    stop()
