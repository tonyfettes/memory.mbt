///|
pub fn malloc[T : Sized + Default + Set](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  Memory::of_array(array)
}

///|
fn _moonbit_incref[T](ptr : FixedArray[T]) -> Unit {
  _array_to_memory(ptr) |> ignore()
}

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _array_sub(_array_of_memory(ptr), 1) |> ignore()
}

///|
fn copy(dest : Memory[Byte], src : Memory[Byte], count : Int) -> Unit {
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
  copy(dest.cast(), ptr.cast(), length)
  free(ptr)
  dest
}
