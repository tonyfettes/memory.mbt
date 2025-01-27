///|
pub fn malloc[T : Sized + Default](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  Memory::of_array(array)
}

///|
extern "c" fn _moonbit_incref(ptr : Memory[Unit]) = "moonbit_incref"

///|
extern "c" fn _moonbit_decref(ptr : Memory[Unit]) = "moonbit_decref"

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _moonbit_decref(ptr.cast().sub(8).cast())
}

///|
fn copy(dest : Memory[Byte], src : Memory[Byte], count : Int) -> Unit {
  for i in 0..<count {
    dest[i] = src[i]
  }
}

///|
pub fn realloc[T : Sized + Default](ptr : Memory[T], size : Int) -> Memory[T] {
  let dest = malloc(size)
  let length = ptr.length()
  copy(dest.cast(), ptr.cast(), length)
  free(ptr)
  dest
}
