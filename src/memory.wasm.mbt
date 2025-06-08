///|
type Memory[_] Int

///|
pub fn[T] to_int(self : Memory[T]) -> Int = "%identity"

///|
fn[T] of_int(value : Int) -> Memory[T] = "%identity"

///|
fn[T] _array_to_int(array : FixedArray[T]) -> Int = "%identity"

///|
fn[T] _array_of_int(value : Int) -> FixedArray[T] = "%identity"

///|
fn _bytes_to_int(bytes : Bytes) -> Int = "%identity"

///|
fn _bytes_of_int(value : Int) -> Bytes = "%identity"

///|
fn _string_to_int(string : String) -> Int = "%identity"

///|
fn _string_of_int(value : Int) -> String = "%identity"

///|
pub fn[T : Sized + Default + Get + Set] to_array(
  self : Memory[T]
) -> FixedArray[T] {
  let array = self.as_array()
  _array_incref(array)
  array
}

///|
fn[T] as_array(self : Memory[T]) -> FixedArray[T] {
  _array_of_int(self.to_int() - 8)
}

///|
pub fn[T : Sized + Default + Set] of_array(array : FixedArray[T]) -> Memory[T] {
  of_int(_array_to_int(array) + 8)
}

///|
pub fn to_bytes(self : Memory[Byte]) -> Bytes {
  let bytes = self.as_bytes()
  _bytes_incref(bytes)
  bytes
}

///|
fn as_bytes(self : Memory[Byte]) -> Bytes {
  _bytes_of_int(self.to_int() - 8)
}

///|
pub fn of_bytes(bytes : Bytes) -> Memory[Byte] {
  of_int(_bytes_to_int(bytes) + 8)
}

///|
pub fn to_string(self : Memory[Byte]) -> String {
  let string = self.as_string()
  _string_incref(string)
  string
}

///|
fn as_string(self : Memory[Byte]) -> String {
  _string_of_int(self.to_int() - 8)
}

///|
pub fn of_string(string : String) -> Memory[Byte] {
  of_int(_string_to_int(string) + 8)
}

///|
pub fn[T : Sized + Default + Get + Set] length(self : Memory[T]) -> Int {
  let array = self.to_array()
  let length = array.length()
  length
}
