///| Memory is a pointer to a block of memory.
type Memory[_] Int

///| convert pointer to int
pub fn Memory::to_int[T](self : Memory[T]) -> Int {
  self._
}

///| memory length with spcialized element type
pub fn Memory::length[T : Sized](self : Memory[T]) -> Int {
  let length = allocator.search_block_length(self._)
  length / T::size()
}

///| 
pub fn Memory::to_array[T : Sized + Get](self : Memory[T]) -> FixedArray[T] {
  let length = self.length()
  if length == 0 {
    return []
  }
  let array = FixedArray::make(length, self[0])
  for i = 1; i < length; i = i + 1 {
    array[i] = self[i]
  }
  array
}

///| allocate memory for an array
pub fn Memory::of_array[T : Sized + Set](array : FixedArray[T]) -> Memory[T] {
  let ptr : Memory[T] = malloc(array.length())
  for i = 0; i < array.length(); i = i + 1 {
    ptr[i] = array[i]
  }
  ptr
}

///| generate a string from memory, doesn't free memory
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  let length = self.length()
  let buffer = @buffer.new()
  for i = 0; i < length * 2; i = i + 1 {
    buffer.write_byte(self[i])
  }
  buffer.contents().to_unchecked_string()
}

///| allocate memory for a string
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  let ptr = malloc(string.length() * 2)
  let bytes = string.to_bytes()
  for i in 0..<bytes.length() {
    ptr[i] = bytes[i]
  }
  ptr
}

///| pointer arithmetic addition
fn ptr_add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}

///| pointer arithmetic addition
fn Memory::add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}
