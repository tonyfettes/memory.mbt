///|
type Memory[_] Int

///|
pub fn Memory::to_int[T](self : Memory[T]) -> Int = "%identity"

///|
fn Memory::of_int[T](value : Int) -> Memory[T] = "%identity"

///|
fn _array_to_int[T](array : FixedArray[T]) -> Int = "%identity"

///|
fn _array_of_int[T](value : Int) -> FixedArray[T] = "%identity"

///|
fn _string_to_int(string : String) -> Int = "%identity"

///|
fn _string_of_int(value : Int) -> String = "%identity"

///|
pub fn Memory::to_array[T : Sized + Default + Get + Set](
  self : Memory[T]
) -> FixedArray[T] {
  _array_of_int(self.to_int() - 8)
}

///|
pub fn Memory::of_array[T : Sized + Default + Set](
  array : FixedArray[T]
) -> Memory[T] {
  Memory::of_int(_array_to_int(array) + 8)
}

///|
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  _string_of_int(self.to_int() - 8)
}

///|
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  Memory::of_int(_string_to_int(string) + 8)
}

///|
pub fn Memory::length[T : Sized + Default + Get + Set](self : Memory[T]) -> Int {
  let array = self.to_array()
  let length = array.length()
  _moonbit_incref(array)
  length
}
