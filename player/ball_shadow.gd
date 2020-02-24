extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var show = false

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func set_display(value):
  show = value

func _process(_delta):
  if $sprite.visible != show:
    $sprite.visible = show
