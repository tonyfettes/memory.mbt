///|
pub fn[T : Sized + Default + Set] malloc(size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  of_array(array)
}

///|
fn[T] _array_incref(ptr : FixedArray[T]) -> Unit = "%identity"

///|
fn _bytes_incref(ptr : Bytes) -> Unit = "%identity"

///|
fn _string_incref(ptr : String) -> Unit = "%identity"

///|
pub fn[T] free(ptr : Memory[T]) -> Unit {
  _array_of_memory(ptr) |> ignore()
}

///|
fn[T : Sized + Get + Set] _copy(
  dest : Memory[T],
  src : Memory[T],
  count : Int
) -> Unit {
  for i in 0..<count {
    dest[i] = src[i]
  }
}

///|
pub fn[T : Sized + Get + Set] blit(
  dst : Memory[T],
  dst_offset : Int,
  src : Memory[T],
  src_offset : Int,
  len : Int
) -> Unit {
  for i in 0..<len {
    dst[dst_offset + i] = src[src_offset + i]
  }
}

///|
pub fn[T : Sized + Default + Get + Set] realloc(
  ptr : Memory[T],
  size : Int
) -> Memory[T] {
  let dest = malloc(size)
  let length = ptr.length()
  _copy(dest, ptr, length)
  free(ptr)
  dest
}
