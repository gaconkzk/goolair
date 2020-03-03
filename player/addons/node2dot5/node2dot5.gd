tool
extends EditorPlugin


func _enter_tree():
  add_custom_type("Base25D", "Node",
    preload("Basis.gd"),
    preload("icons/node25d_icon.png"))
  add_custom_type("Node25D", "Node2D",
    preload("Node.gd"),
    preload("icons/node25d_icon.png"))
  add_custom_type("ShadowMath25D", "KinematicBody",
    preload("ShadowMath.gd"),
    preload("icons/shadowmath25d_icon.png"))

func _exit_tree():
  remove_custom_type("Node25D")
