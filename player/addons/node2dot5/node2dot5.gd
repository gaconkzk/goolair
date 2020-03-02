tool
extends EditorPlugin


func _enter_tree():
  add_custom_type("Node25D", "Node2D",
    preload("res://addons/node2dot5/Node25D.gd"),
    preload("res://addons/node2dot5/icons/node25d_icon.png"))

func _exit_tree():
  remove_custom_type("Node25D")
