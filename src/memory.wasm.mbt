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
pub fn Memory::to_array[T](self : Memory[T]) -> FixedArray[T] {
  let address = self.to_int()
  _moonbit_incref(address - 8)
  let array = _array_of_int(address - 8)
  array
}

///|
pub fn Memory::of_array[T](array : FixedArray[T]) -> Memory[T] {
  let address = _array_to_int(array)
  Memory::of_int(address + 8)
}

///|
pub fn Memory::to_string[T](self : Memory[T]) -> String {
  let address = self.to_int()
  _moonbit_incref(address - 8)
  _string_of_int(address - 8)
}

///|
pub fn Memory::of_string[T](string : String) -> Memory[T] {
  let address = _string_to_int(string)
  Memory::of_int(address + 8)
}

///|
pub fn Memory::length[T](self : Memory[T]) -> Int {
  let array = self.to_array()
  array.length()
}
