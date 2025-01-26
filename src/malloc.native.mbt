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
pub fn free[T](self : Memory[T]) -> Unit {
  _moonbit_decref(self.cast().sub(8).cast())
}

///|
fn copy(dest : Memory[Byte], src : Memory[Byte], count : Int) -> Unit {
  for i in 0..<count {
    dest[i] = src[i]
  }
}

///|
pub fn realloc[T : Sized + Default](self : Memory[T], size : Int) -> Memory[T] {
  let dest = malloc(size)
  let length = self.length()
  copy(dest.cast(), self.cast(), length)
  free(self)
  dest
}
