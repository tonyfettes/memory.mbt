///|
type Memory[_]

///|
pub fn to_int[T](self : Memory[T]) -> Int {
  let _ = self
  panic()
}

///|
fn _array_to_memory[T](ptr : FixedArray[T]) -> Memory[T] = "%identity"

///|
fn _array_of_memory[T](value : Memory[T]) -> FixedArray[T] = "%identity"

///|
fn _bytes_to_memory(ptr : Bytes) -> Memory[Byte] = "%identity"

///|
fn _bytes_of_memory(value : Memory[Byte]) -> Bytes = "%identity"

///|
fn _string_to_memory(ptr : String) -> Memory[Byte] = "%identity"

///|
fn _string_of_memory(value : Memory[Byte]) -> String = "%identity"

///|
fn Memory::cast[T, U](self : Memory[T]) -> Memory[U] = "%identity"

///|
/// This will be compiled as `+` and will be inlined. This way we can bypass the
/// typecheck on the C side.
fn _array_add[T](array : FixedArray[T], offset : Int) -> FixedArray[T] = "%u64.add"

///|
fn _array_sub[T](array : FixedArray[T], offset : Int) -> FixedArray[T] = "%u64.sub"

///|
fn _bytes_add(bytes : Bytes, offset : Int) -> Bytes = "%u64.add"

///|
fn _bytes_sub(bytes : Bytes, offset : Int) -> Bytes = "%u64.sub"

///|
fn _string_add(string : String, offset : Int) -> String = "%u64.add"

///|
fn _string_sub(string : String, offset : Int) -> String = "%u64.sub"

///|
pub fn to_array[T : Sized + Default + Get + Set](
  self : Memory[T]
) -> FixedArray[T] {
  let array = _array_sub(_array_of_memory(self), 1)
  _array_incref(array)
  array
}

///|
pub fn of_array[T : Sized + Default + Set](array : FixedArray[T]) -> Memory[T] {
  _array_to_memory(_array_add(array, 1))
}

///|
pub fn to_bytes(self : Memory[Byte]) -> Bytes {
  let bytes = _bytes_sub(_bytes_of_memory(self), 1)
  _bytes_incref(bytes)
  bytes
}

///|
pub fn of_bytes(bytes : Bytes) -> Memory[Byte] {
  _bytes_to_memory(_bytes_add(bytes, 1))
}

///|
pub fn to_string(self : Memory[Byte]) -> String {
  let string = _string_sub(_string_of_memory(self), 1)
  _string_incref(string)
  string
}

///|
pub fn of_string(string : String) -> Memory[Byte] {
  _string_to_memory(_string_add(string, 1))
}

///|
pub fn length[T : Sized + Default + Get + Set](self : Memory[T]) -> Int {
  let array = self.to_array()
  let length = array.length()
  length
}
