///|
pub fn malloc[T : Sized + Default + Set](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  Memory::of_array(array)
}

///|
fn _array_incref[T](ptr : FixedArray[T]) -> Unit {
  _array_to_memory(ptr) |> ignore()
}

///|
fn _string_incref(ptr : String) -> Unit {
  _string_to_memory(ptr) |> ignore()
}

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _array_sub(_array_of_memory(ptr), 1) |> ignore()
}

///|
fn copy[T : Sized + Get + Set](
  dest : Memory[T],
  src : Memory[T],
  count : Int
) -> Unit {
  for i in 0..<count {
    dest[i] = src[i]
  }
}

///|
pub fn realloc[T : Sized + Default + Get + Set](
  ptr : Memory[T],
  size : Int
) -> Memory[T] {
  let dest = malloc(size)
  let length = ptr.length()
  copy(dest, ptr, length)
  free(ptr)
  dest
}
