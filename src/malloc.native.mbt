///|
pub fn malloc[T : Sized + Default + Set](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  of_array(array)
}

///|
fn _array_incref[T](ptr : FixedArray[T]) -> Unit = "%identity"

///|
fn _bytes_incref(ptr : Bytes) -> Unit = "%identity"

///|
fn _string_incref(ptr : String) -> Unit = "%identity"

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _array_sub(_array_of_memory(ptr), 1) |> ignore()
}

///|
fn _copy[T : Sized + Get + Set](
  dest : Memory[T],
  src : Memory[T],
  count : Int
) -> Unit {
  for i in 0..<count {
    dest[i] = src[i]
  }
}

///|
pub fn blit[T : Sized + Get + Set](
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
pub fn realloc[T : Sized + Default + Get + Set](
  ptr : Memory[T],
  size : Int
) -> Memory[T] {
  let dest = malloc(size)
  let length = ptr.length()
  _copy(dest, ptr, length)
  free(ptr)
  dest
}
