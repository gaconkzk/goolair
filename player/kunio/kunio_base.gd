extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var body_texture_1 = preload("res://kunio/assets/body_ukia_1.png")
var head_texture_1 = preload("res://kunio/assets/head_ukia_1.png")
var hand_texture_1 = preload("res://kunio/assets/hand_ukia_1.png")

var body_texture_2 = preload("res://kunio/assets/body_ukia_2.png")
var head_texture_2 = preload("res://kunio/assets/head_ukia_2.png")
var hand_texture_2 = preload("res://kunio/assets/hand_ukia_2.png")

var ppl
var is_running = false

var sf_full

# Called when the node enters the scene tree for the first time.
func _ready():
  ppl = [$fanim]
  sf_full = LargeTexture.new()
  sf_full.set_size(Vector2(64,64))
  sf_full.add_piece(Vector2(0,0), body_texture_1)
  sf_full.add_piece(Vector2(0,0), hand_texture_1)
  sf_full.add_piece(Vector2(0,0), head_texture_1)
  
  var sf_full_1 = LargeTexture.new()
  sf_full_1.set_size(Vector2(64,64))
  sf_full_1.add_piece(Vector2(0,0), body_texture_2)
  sf_full_1.add_piece(Vector2(0,0), hand_texture_2)
  sf_full_1.add_piece(Vector2(0,0), head_texture_2)
  
  var sf = SpriteFrames.new()
  sf.add_animation("run")
  sf.add_frame("run", sf_full)
  sf.add_frame("run", sf_full_1)
  $fanim.frames = sf
  $fanim.animation = "run"

func run():
  for part in ppl:
    if Input.is_action_pressed("ui_left"):
      part.flip_h = true
    if Input.is_action_pressed("ui_right"):
      part.flip_h = false
  for part in ppl:
    part.play()
  is_running = true

func stop():
  for part in ppl:
    part.stop()
    part.frame = 0
  is_running = false
  

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var action_pressed = Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_down") || Input.is_action_pressed("ui_up")
  if action_pressed:
    run()
  # elif is_running:
  else:
    stop()
