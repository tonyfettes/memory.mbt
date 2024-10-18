test "malloc - free" {
  let ptr = @memory.malloc(8)
  @memory.free(ptr)
}

test "malloc - store - free" {
  let ptr = @memory.malloc(8)
  @memory.store64(ptr, 42)
  @memory.free(ptr)
}

test "malloc0 - malloc1 - free0 - free1" {
  let ptr0 = @memory.malloc(8)
  let ptr1 = @memory.malloc(8)
  @memory.free(ptr0)
  @memory.free(ptr1)
}

test "malloc0 - malloc1 - free1 - free0" {
  let ptr0 = @memory.malloc(8)
  let ptr1 = @memory.malloc(8)
  @memory.free(ptr1)
  @memory.free(ptr0)
}

test "malloc - realloc - free" {
  let ptr = @memory.malloc(8)
  let ptr = @memory.realloc(ptr, 16)
  @memory.free(ptr)
}
