# Adds a simple shadow below an object.
# Place this ShadowMath25D node as a child of a Shadow25D, which
# is below the target object in the scene tree (not as a child).
tool
extends KinematicBody
class_name ShadowMath25D, "icons/shadowmath25d_icon.png"

export(NodePath) onready var target_path setget set_target_path

# The maximum distance below objects that shadows will appear (in 3D units).
var shadow_length = 1000.0
var _shadow_root: Node25D
var _target_math: Spatial

func _shadow_math_filter(node) -> bool:
  if node is Spatial and "math" in node.name:
    return true
  else:
    return false

func _ready():
  _shadow_root = get_parent()
  _target_math = get_node(target_path)

func set_target_path(value):
    target_path = value
    if has_node(value):
      _target_math = get_node(value)

func _process(_delta):
  if _target_math == null:
    if _shadow_root != null:
      _shadow_root.visible = false
    return # Shadow is not in a valid place or you're viewing the Shadow25D scene.
  
  translation = _target_math.translation
  var k = move_and_collide(Vector3.DOWN * shadow_length)
  
  var h = _target_math.get_parent().get_spatial_position()
  if _shadow_root:
    if k == null || h.y <= 0.01:
      _shadow_root.visible = false
    else:
      _shadow_root.visible = true
      global_transform = transform
