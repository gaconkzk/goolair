# Currently broken unless Godot makes this kind of thing possible:
# https://github.com/godotengine/godot/issues/21461
# https://github.com/godotengine/godot-proposals/issues/279

# Basis25D structure for performing 2.5D transform math.
# Note: All code assumes that Y is UP in 3D, and DOWN in 2D.
# Meaning, a top-down view has a Y axis component of (0, 0), with a Z axis component of (0, 1).
# For a front side view, Y is (0, -1) and Z is (0, 0).
# Remember that Godot's 2D mode has the Y axis pointing DOWN on the screen.
class_name Basis25D

enum PERSPECTIVE { top_down, front_side, forty_five, isometric, oblique_y, oblique_z }

var perspective = PERSPECTIVE.forty_five setget set_perspective

var SCALE = 32

var x: Vector2 = Vector2()
var y: Vector2 = Vector2()
var z: Vector2 = Vector2()

func _init():
  set_perspective(perspective)

func set_perspective(value):
  perspective = value
  match perspective:
    PERSPECTIVE.top_down:
      top_down()
    PERSPECTIVE.front_side:
      front_side()
    PERSPECTIVE.forty_five:
      forty_five()
    PERSPECTIVE.isometric:
      isometric()
    PERSPECTIVE.oblique_y:
      oblique_y()
    PERSPECTIVE.oblique_z:
      oblique_z()

func _perspective(xx, xy, yx, yy, zx, zy):
  x = SCALE * Vector2(xx, xy)
  y = SCALE * Vector2(yx, yy)
  z = SCALE * Vector2(zx, zy)

func top_down():
  _perspective(1, 0, 0, 0, 0, 1)

func front_side():
  _perspective(1, 0, 0, -1, 0, 0)

func forty_five():
  _perspective(1, 0, 0, -0.70710678118, 0, 0.70710678118)

func isometric():
  _perspective(0.86602540378, 0.5, 0, -1, -0.86602540378, 0.5)

func oblique_y():
  _perspective(1, 0, -1, -1, 0, 1)

func oblique_z():
  _perspective(1, 0, 0, -1, -1, 1)

# Creates a Dimetric Basis25D from the angle between the Y axis and the others.
# Dimetric(2.09439510239) is the same as Isometric.
# Try to keep this number away from a multiple of Tau/4 (or Pi/2) radians.
func dimetric(angle):
  var sine = sin(angle)
  var cosine = cos(angle)
  _perspective(sine, -cosine, 0, -1, -sine, -cosine)
