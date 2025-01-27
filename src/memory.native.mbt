///|
pub type Memory[_]

///|
fn _array_to_memory[T](ptr : FixedArray[T]) -> Memory[T] = "%identity"

///|
fn _array_of_memory[T](value : Memory[T]) -> FixedArray[T] = "%identity"

///|
fn _string_to_memory(ptr : String) -> Memory[Byte] = "%identity"

///|
fn _string_of_memory(value : Memory[Byte]) -> String = "%identity"

///|
fn Memory::cast[T, U](self : Memory[T]) -> Memory[U] = "%identity"

///|
/// This will be compiled as `+` and will be inlined. This way we can bypass the
/// typecheck on the C side.
fn Memory::add(self : Memory[Unit], offset : Int) -> Memory[Unit] = "%u64.add"

///|
fn Memory::sub(self : Memory[Unit], offset : Int) -> Memory[Unit] = "%u64.sub"

///|
pub fn Memory::to_array[T](self : Memory[T]) -> FixedArray[T] {
  _moonbit_incref(self.cast().sub(8).cast())
  _array_of_memory(self.cast().sub(8).cast())
}

///|
pub fn Memory::of_array[T](array : FixedArray[T]) -> Memory[T] {
  let memory = _array_to_memory(array)
  memory.cast().add(8).cast()
}

///|
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  _moonbit_incref(self.cast().sub(8).cast())
  _string_of_memory(self.cast().sub(8).cast())
}

///|
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  let memory : Memory[Byte] = _string_to_memory(string)
  memory.cast().add(8).cast()
}

///|
pub fn Memory::length[T : Sized](self : Memory[T]) -> Int {
  let array = self.to_array()
  array.length()
}
