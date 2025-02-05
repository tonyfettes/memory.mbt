///|
pub fn malloc[T : Sized + Default](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  Memory::of_array(array)
}

///|
fn _moonbit_incref(ptr : Int) = "$moonbit.incref"

///|
fn _moonbit_decref(ptr : Int) = "$moonbit.decref"

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _moonbit_decref(ptr._ - 8)
}

///|
fn copy(dest : Int, src : Int, len : Int) -> Unit {
  let src = src - 8
  let dst = dest - 8
  @wasm.memory_copy(dst, src, 8 + len)
}

///|
pub fn realloc[T : Sized + Default](ptr : Memory[T], size : Int) -> Memory[T] {
  let dst = malloc(size)
  let src_len = ptr.length()
  copy(dst._, ptr._, src_len)
  free(ptr)
  dst
}
