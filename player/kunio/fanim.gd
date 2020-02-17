tool
extends AnimatedSprite

class_name NekAnimatedSprite

# String is a path to a directory.
export(String, FILE) var sprite_metadata setget set_sprite_metadata

export(String, "stand", "run", "walk") var default_animation setget update_default_animation

var head = "kunio" setget set_head

func set_head(value):
  # update head
  head = value
  set_sprite_metadata(sprite_metadata)

func update_default_animation(value):
  default_animation = value
  self.animation = default_animation

func create_frames(head, fs):
  var farr = []
  if fs.size() > 0:
    for f in fs:
      var texture = LargeTexture.new()
      texture.set_size(Vector2(f["size"]["width"], f["size"]["height"]))
      texture.add_piece(Vector2(), head)
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

func create_head(dict_head, path):
  var h
  if head:
    h = head
  else:
    h = dict_head
  
  var p = path if path else "res://kunio/assets/parts"
  var head_texture = load("%s/head/%s.png" % [p, h])
  return head_texture

func set_sprite_metadata(value):
  sprite_metadata = value
  if value:
    var data_file = File.new()
    data_file.open(sprite_metadata, data_file.READ)
    var data = data_file.get_as_text()
    data_file.close()
    
    var dict = parse_json(data)
    var head = create_head(dict["head"], dict["parts"])
    var farray = create_frames(head, dict["frames"])
    frames = create_animations(farray, dict["animations"])
    animation = dict["default"]
  else:
    frames = null

