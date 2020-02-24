extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var show = false setget set_display

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.

func set_display(value):
  show = value
  $sprite.visible = show
