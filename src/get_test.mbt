///|
test "get/Int16" {
  let ptr : Memory[Int16] = malloc(2)
  ptr[0] = 42
  inspect!(ptr[0], content="42")
  free(ptr)
}

///|
test "get/UInt16" {
  let ptr : Memory[UInt16] = malloc(2)
  ptr[0] = 42
  ptr[1] = 84
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}

///|
test "get/Int" {
  let ptr : Memory[Int] = malloc(2)
  ptr[0] = 42
  inspect!(ptr[0], content="42")
  free(ptr)
}

///|
test "get/UInt" {
  let ptr : Memory[UInt] = malloc(2)
  ptr[0] = 42
  ptr[1] = 84
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}

///|
test "get/Int64" {
  let ptr : Memory[Int64] = malloc(2)
  ptr[0] = 42
  ptr[1] = 84
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}

///|
test "get/UInt64" {
  let ptr : Memory[UInt64] = malloc(2)
  ptr[0] = 42
  ptr[1] = 84
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}

///|
test "get/Float" {
  let ptr : Memory[Float] = malloc(2)
  ptr[0] = 42.0
  ptr[1] = 84.0
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}

///|
test "get/Double" {
  let ptr : Memory[Double] = malloc(2)
  ptr[0] = 42.0
  ptr[1] = 84.0
  inspect!(ptr[0], content="42")
  inspect!(ptr[1], content="84")
  free(ptr)
}
