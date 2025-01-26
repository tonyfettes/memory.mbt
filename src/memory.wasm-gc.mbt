///|
type Memory[_] Int

///|
pub fn Memory::as_int[T](self : Memory[T]) -> Int {
  self._
}

///|
pub fn Memory::length[T : Sized](self : Memory[T]) -> Int {
  let length = allocator.search_block_length(self._)
  length / T::size()
}

///|
pub fn Memory::to_array[T : Sized + Get + Default](
  self : Memory[T]
) -> FixedArray[T] {
  let length = self.length()
  let array = FixedArray::make(length, T::default())
  for i = 0; i < length; i = i + 1 {
    array[i] = self[i]
  }
  array
}

///|
pub fn Memory::of_array[T : Sized + Default + Set + Show](
  array : FixedArray[T]
) -> Memory[T] {
  let ptr : Memory[T] = malloc(array.length())
  for i = 0; i < array.length(); i = i + 1 {
    ptr[i] = array[i]
  }
  ptr
}

///|
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  let length = self.length()
  let buffer = @buffer.new()
  for i = 0; i < length * 2; i = i + 1 {
    buffer.write_byte(self[i])
  }
  buffer.contents().to_unchecked_string()
}

///|
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  let ptr = malloc(string.length() * 2)
  let bytes = string.to_bytes()
  for i in 0..<bytes.length() {
    ptr[i] = bytes[i]
  }
  ptr
}

///|
fn ptr_add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}

///|
pub fn Memory::add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}
