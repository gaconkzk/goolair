extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  var action_pressed = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
  if action_pressed:
    if Input.is_action_pressed("ui_left"):
      $AnimatedSprite.flip_h = true
    if Input.is_action_pressed("ui_right"):
      $AnimatedSprite.flip_h = false
    $AnimatedSprite.play("run")
  else:
    $AnimatedSprite.stop()
    $AnimatedSprite.frame = 0
