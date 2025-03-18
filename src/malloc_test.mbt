///|
test "malloc-free/Byte" {
  let ptr : Memory[Byte] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/Int" {
  let ptr : Memory[Int] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/UInt" {
  let ptr : Memory[UInt] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/Int64" {
  let ptr : Memory[Int64] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/UInt64" {
  let ptr : Memory[UInt64] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/Float" {
  let ptr : Memory[Float] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-free/Double" {
  let ptr : Memory[Double] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc-store-free" {
  let ptr : Memory[Int64] = @memory.malloc(8)
  ptr[0] = 42
  @memory.free(ptr)
}

///|
test "malloc0-malloc1-free0-free1" {
  let ptr0 : Memory[Byte] = @memory.malloc(8)
  ptr0[0] = 4
  let ptr1 : Memory[Byte] = @memory.malloc(8)
  ptr1[0] = 2
  @memory.free(ptr0)
  @memory.free(ptr1)
}

///|
test "malloc0-malloc1-free1-free0" {
  let ptr0 : Memory[Byte] = @memory.malloc(8)
  ptr0[0] = 4
  let ptr1 : Memory[Byte] = @memory.malloc(8)
  ptr1[0] = 2
  @memory.free(ptr1)
  @memory.free(ptr0)
}

///|
test "malloc-realloc-free" {
  let ptr : Memory[Byte] = @memory.malloc(8)
  ptr[0] = 4
  ptr[1] = 2
  let ptr : Memory[Byte] = @memory.realloc(ptr, 16)
  @json.inspect!(ptr[0].to_int(), content=4)
  @json.inspect!(ptr[1].to_int(), content=2)
  @memory.free(ptr)
}

///|
test "blit" {
  let dst : Memory[Int] = @memory.malloc(8)
  let src : Memory[Int] = @memory.malloc(8)
  src[0] = 4
  src[1] = 2
  @memory.blit(dst, 0, src, 0, 2)
  @json.inspect!(dst[0], content=4)
  @json.inspect!(dst[1], content=2)
  @memory.free(dst)
  @memory.free(src)
}
