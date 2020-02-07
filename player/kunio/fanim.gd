tool
extends AnimatedSprite

class_name NekAnimatedSprite

# String is a path to a directory.
export(String, FILE) var sprite_metadata setget set_sprite_metadata

var body_texture_1 = preload("res://kunio/assets/body_ukia_1.png")
var head_texture_1 = preload("res://kunio/assets/head_ukia_1.png")
var hand_texture_1 = preload("res://kunio/assets/hand_ukia_1.png")

var body_texture_2 = preload("res://kunio/assets/body_ukia_2.png")
var head_texture_2 = preload("res://kunio/assets/head_ukia_2.png")
var hand_texture_2 = preload("res://kunio/assets/hand_ukia_2.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
export(Color, RGBA) var clothes_color = Color("#ffffff") setget update_clothes

func update_clothes(value):
  clothes_color = value
  if value:
    self.material.set_shader_param("clothes", value)


func create_frames(fs):
  var farr = []
  if fs.size() > 0:
    for f in fs:
      var texture = LargeTexture.new()
      texture.set_size(Vector2(f["size"]["width"], f["size"]["height"]))
      for pieces in f["pieces"]:
        var prltx = load(pieces)
        texture.add_piece(Vector2(0, 0), prltx)
      farr.append(texture)
  return farr

func create_animations(farr, animations):
  var sf = SpriteFrames.new()
  sf.remove_animation("default")
  if animations.size() > 0:
    for anim in animations:
      sf.add_animation(anim["name"])
      for idx in anim["frames"]:
        sf.add_frame(anim["name"], farr[idx])
      sf.set_animation_speed(anim["name"], anim["speed"])
      sf.set_animation_loop(anim["name"], anim["loop"])
  return sf

func set_sprite_metadata(value):
  sprite_metadata = value
  if value:
    var data_file = File.new()
    data_file.open(sprite_metadata, data_file.READ)
    var data = data_file.get_as_text()
    data_file.close()
    
    var dict = parse_json(data)
    var farray = create_frames(dict["frames"])
    frames = create_animations(farray, dict["animations"])
    animation = dict["default"]
  else:
    frames = null
