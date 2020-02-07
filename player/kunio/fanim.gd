tool
extends AnimatedSprite

class_name NekAnimatedSprite

# String is a path to a directory.
export(String, FILE) var sprite_metadata = null

var body_texture_1 = preload("res://kunio/assets/body_ukia_1.png")
var head_texture_1 = preload("res://kunio/assets/head_ukia_1.png")
var hand_texture_1 = preload("res://kunio/assets/hand_ukia_1.png")

var body_texture_2 = preload("res://kunio/assets/body_ukia_2.png")
var head_texture_2 = preload("res://kunio/assets/head_ukia_2.png")
var hand_texture_2 = preload("res://kunio/assets/hand_ukia_2.png")

func _get_configuration_warning() -> String:
  if not sprite_metadata:
    return 'Assets folder must be declared.'
  return ''

# Called when the node enters the scene tree for the first time.
func _ready():
  pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
func _init():
  if not sprite_metadata:
    push_warning("SpriteMetadata must be existed.")
    return

  var data_file = File.new()
  data_file.open(sprite_metadata, data_file.READ)
  var data = data_file.get_as_text()
  data_file.close()
  
  print(data)

  self.frames = SpriteFrames.new()
  
  var sf_full = LargeTexture.new()
  sf_full.set_size(Vector2(64,64))
  sf_full.add_piece(Vector2(0,0), body_texture_1)
  sf_full.add_piece(Vector2(0,0), hand_texture_1)
  sf_full.add_piece(Vector2(0,0), head_texture_1)
  
  var sf_full_1 = LargeTexture.new()
  sf_full_1.set_size(Vector2(64,64))
  sf_full_1.add_piece(Vector2(0,0), body_texture_2)
  sf_full_1.add_piece(Vector2(0,0), hand_texture_2)
  sf_full_1.add_piece(Vector2(0,0), head_texture_2)
  
  self.frames = SpriteFrames.new()
  self.frames.remove_animation("default")
  
  self.frames.add_animation("stand")
  self.frames.add_frame("stand", sf_full)
  self.frames.set_animation_speed("stand", 0)
  self.frames.set_animation_loop("stand", false)
  
  self.frames.add_animation("run")
  self.frames.add_frame("run", sf_full)
  self.frames.add_frame("run", sf_full_1)
  self.frames.set_animation_speed("run", 7)
  
  self.animation = "stand"
