///|
pub fn malloc[T : Sized + Default + Set](size : Int) -> Memory[T] {
  let array = FixedArray::make(size, T::default())
  Memory::of_array(array)
}

///|
fn _array_incref[T](ptr : FixedArray[T]) -> Unit {
  _array_to_int(ptr) |> ignore()
}

///|
fn _bytes_incref(ptr : Bytes) -> Unit {
  _bytes_to_int(ptr) |> ignore()
}

///|
fn _string_incref(ptr : String) -> Unit {
  _string_to_int(ptr) |> ignore()
}

///|
fn _moonbit_decref(ptr : Int) = "$moonbit.decref"

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  _moonbit_decref(ptr._ - 8)
}

///|
fn _copy(dest : Int, src : Int, len : Int) -> Unit {
  @wasm.memory_copy(dest, src, len)
}

///|
pub fn blit[T : Sized + Get + Set](
  dst : Memory[T],
  dst_offset : Int,
  src : Memory[T],
  src_offset : Int,
  len : Int
) -> Unit {
  _copy(
    dst._ + dst_offset * T::size(),
    src._ + src_offset * T::size(),
    len * T::size(),
  )
}

///|
pub fn realloc[T : Sized + Default + Get + Set](
  ptr : Memory[T],
  size : Int
) -> Memory[T] {
  let dst = malloc(size)
  let src_len = ptr.length()
  _copy(dst._, ptr._, src_len * T::size())
  free(ptr)
  dst
}
