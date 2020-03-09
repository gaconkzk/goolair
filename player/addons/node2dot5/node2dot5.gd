tool
extends EditorPlugin

const MainPanel = preload("res://addons/node2dot5/main_screen/main_screen_25d.tscn")

var main_panel_instance

func _enter_tree():
  main_panel_instance = MainPanel.instance()
  
  main_panel_instance.get_child(1).editor_interface = get_editor_interface()
  
  get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
  
  make_visible(false)

  add_custom_type("Node25D", "Node2D",
    preload("Node.gd"),
    preload("icons/node25d_icon.png"))
  add_custom_type("YSort25D", "Node",
    preload("y_sort_25d.gd"),
    preload("icons/ysort25d_icon.png"))
  add_custom_type("ShadowMath25D", "KinematicBody",
    preload("ShadowMath.gd"),
    preload("icons/shadowmath25d_icon.png"))

func _exit_tree():
  remove_custom_type("ShadowMath25D")
  remove_custom_type("YSort25D")
  remove_custom_type("Node25D")

func has_main_screen():
  return true

func make_visible(visible):
  if visible:
    main_panel_instance.show()
  else:
    main_panel_instance.hide()

func get_plugin_name():
  return "2.5D"

func get_plugin_icon():
  return preload("res://addons/node2dot5/icons/viewport_25d.svg")
