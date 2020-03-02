# Handles Player-specific behavior like moving. We calculate such things with KinematicBody.
extends KinematicBody
class_name KinematicBody25D # No icon necessary

onready var _parent_node25d: Node25D = get_parent()
