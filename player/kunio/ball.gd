extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prev_pos = position
var velocity = Vector2()

var dir = true
var prev_dir = true

var rolling = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

func _physics_process(_delta):
  velocity = position - prev_pos
  prev_pos = position
  
  rolling = velocity != Vector2(0, 0)
  var left = velocity.x > 0
  var right = velocity.x < 0
  if (left && !dir):
    dir = left
  elif right && dir:
    dir = right

func _process(_delta):
  $img.playing = rolling
  if prev_dir != dir:
    $img.flip_h = dir
    prev_dir = dir
