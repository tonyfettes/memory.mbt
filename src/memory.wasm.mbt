///|
type Memory[_] Int

///|
pub fn to_int[T](self : Memory[T]) -> Int = "%identity"

///|
fn of_int[T](value : Int) -> Memory[T] = "%identity"

///|
fn _array_to_int[T](array : FixedArray[T]) -> Int = "%identity"

///|
fn _array_of_int[T](value : Int) -> FixedArray[T] = "%identity"

///|
fn _bytes_to_int(bytes : Bytes) -> Int = "%identity"

///|
fn _bytes_of_int(value : Int) -> Bytes = "%identity"

///|
fn _string_to_int(string : String) -> Int = "%identity"

///|
fn _string_of_int(value : Int) -> String = "%identity"

///|
pub fn to_array[T : Sized + Default + Get + Set](
  self : Memory[T]
) -> FixedArray[T] {
  let array = self.as_array()
  _array_incref(array)
  array
}

///|
pub fn as_array[T](self : Memory[T]) -> FixedArray[T] {
  _array_of_int(self.to_int() - 8)
}

///|
pub fn of_array[T : Sized + Default + Set](array : FixedArray[T]) -> Memory[T] {
  of_int(_array_to_int(array) + 8)
}

///|
pub fn to_bytes(self : Memory[Byte]) -> Bytes {
  let bytes = self.as_bytes()
  _bytes_incref(bytes)
  bytes
}

///|
pub fn as_bytes(self : Memory[Byte]) -> Bytes {
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
pub fn as_string(self : Memory[Byte]) -> String {
  _string_of_int(self.to_int() - 8)
}

///|
pub fn of_string(string : String) -> Memory[Byte] {
  of_int(_string_to_int(string) + 8)
}

///|
pub fn length[T : Sized + Default + Get + Set](self : Memory[T]) -> Int {
  let array = self.to_array()
  let length = array.length()
  length
}
