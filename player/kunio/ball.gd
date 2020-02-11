extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2()
var rotation_dir = 0
var rotation_speed = 2
var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass

func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
        rotation_dir += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
        rotation_dir -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y += 1
        rotation_dir += 2
    if Input.is_action_pressed('ui_up'):
        velocity.y -= 1
        rotation_dir -= 2
    velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    rotation = rotation_dir * rotation_speed * delta
    velocity = move_and_slide(velocity)
