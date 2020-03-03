class_name CollectionsUtil

static func map(function: FuncRef, i_array: Array) -> Array:
  var o_array := []
  for value in i_array:
    o_array.append(function.call_func(value))
  return o_array

static func filter(function: FuncRef, i_array: Array) -> Array:
  var o_array := []
  for value in i_array:
    if (function.call_func(value)):
      o_array.append(value)
  return o_array

static func find(function: FuncRef, i_array: Array) -> Object:
  for value in i_array:
    if (function.call_func(value)):
      return value
  return null

static func reduce(function: FuncRef, i_array: Array, first = null) -> Array:
  var acc = first
  var start := 0
  
  if acc == null:
    acc = i_array[0]
    start = 1
  
  for index in range(start, i_array.size()):
    acc = function.call_func(acc, i_array[index])
  
  return acc
