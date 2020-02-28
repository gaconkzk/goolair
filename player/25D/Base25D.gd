const Node25D = preload("Node25D.gd")

# Used by YSort25D
static func y_sort(a: Node25D, b: Node25D):
  return a._spatial_position.y < b._spatial_position.y


static func y_sort_slight_xz(a: Node25D, b: Node25D):
  var a_index = a._spatial_position.y + 0.001 * (a._spatial_position.x + a._spatial_position.z)
  var b_index = b._spatial_position.y + 0.001 * (b._spatial_position.x + b._spatial_position.z)
  return a_index < b_index
