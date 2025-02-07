///| Memory is a pointer to a block of memory.
type Memory[_] Int

///| Converts pointer to int
pub fn Memory::to_int[T](self : Memory[T]) -> Int {
  self._
}

///|
/// Returns the number of elements in the memory block.
///
/// Parameters:
///
/// * `memory` : A pointer to the memory block. The type parameter `T` must
/// implement the `Sized`, `Default`, `Get`, and `Set` traits.
///
/// Returns the number of elements in the memory block based on the size of type
/// `T`.
///
/// Example:
///
/// ```moonbit
/// test "Memory::length" {
///   let ptr : Memory[Int] = malloc(4)
///   inspect!(ptr.length(), content="4")
///   free(ptr)
/// }
/// ```
pub fn Memory::length[T : Sized + Default + Get + Set](self : Memory[T]) -> Int {
  let length = allocator.search_block_length(self._)
  length / T::size()
}

///|
/// Creates a fixed-size array from a memory block, copying all elements from the
/// memory block to the new array.
///
/// Parameters:
///
/// * `memory` : A memory block containing elements of type `T`. The type `T`
/// must implement the `Sized`, `Default`, `Get`, and `Set` traits.
///
/// Returns a new fixed-size array containing all elements from the memory block.
///
/// Example:
///
/// ```moonbit
/// test "Memory::to_array" {
///   let ptr : Memory[Int] = malloc(3)
///   ptr[0] = 1
///   ptr[1] = 2
///   ptr[2] = 3
///   let array = ptr.to_array()
///   inspect!(array, content="[1, 2, 3]")
///   free(ptr)
/// }
/// ```
pub fn Memory::to_array[T : Sized + Default + Get + Set](
  self : Memory[T]
) -> FixedArray[T] {
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

///|
/// Allocates a new memory block and copies the contents of a fixed-size array
/// into it.
///
/// Parameters:
///
/// * `array` : A fixed-size array containing the elements to be copied into the
/// new memory block. The element type must implement `Sized`, `Default`, and
/// `Set` traits.
///
/// Returns a pointer to the newly allocated memory block containing a copy of
/// the array's contents.
///
/// Example:
///
/// ```moonbit
/// test "Memory::of_array" {
///   let array : FixedArray[Int] = [1, 2, 3]
///   let ptr : Memory[Int] = Memory::of_array(array)
///   inspect!(ptr[0], content="1")
///   inspect!(ptr.length(), content="3")
///   free(ptr)
/// }
/// ```
pub fn Memory::of_array[T : Sized + Default + Set](
  array : FixedArray[T]
) -> Memory[T] {
  let ptr : Memory[T] = malloc(array.length())
  for i = 0; i < array.length(); i = i + 1 {
    ptr[i] = array[i]
  }
  ptr
}

///|
/// Converts a memory block containing bytes into a byte sequence. The memory
/// block remains unchanged after the conversion.
///
/// Parameters:
///
/// * `memory` : A pointer to a block of memory containing bytes. The memory
/// block should be properly allocated and initialized before calling this
/// function.
///
/// Returns a new `Bytes` value containing a copy of the bytes stored in the
/// memory block.
///
/// Example:
///
/// ```moonbit
/// test "Memory::to_bytes" {
///   let ptr : Memory[Byte] = malloc(4)
///   ptr[0] = b'H'
///   ptr[1] = b'\x00'
///   ptr[2] = b'i'
///   ptr[3] = b'\x00'
///   let bytes = ptr.to_bytes()
///   inspect!(bytes.to_unchecked_string(), content="Hi")
///   free(ptr)
/// }
/// ```
pub fn Memory::to_bytes(self : Memory[Byte]) -> Bytes {
  let length = self.length()
  let buffer = @buffer.new()
  for i = 0; i < length; i = i + 1 {
    buffer.write_byte(self[i])
  }
  buffer.contents()
}

///|
/// Performs pointer arithmetic addition by advancing the memory
/// pointer by a specified number of positions. This is a private function used
/// internally by the package.
///
/// Parameters:
///
/// * `pointer` : A pointer of type `Memory[T]` where `T` implements the `Sized`
/// trait.
/// * `offset` : The number of positions to advance the pointer. Each position
/// corresponds to the size of type `T`.
///
/// Returns a new pointer of type `Memory[T]` that points to the memory location
/// after advancing by the specified offset.
///
/// Example:
///
/// ```moonbit
/// test "Memory::op_get" {
///   let ptr : Memory[Int] = malloc(4)
///   ptr[0] = 42
///   ptr[1] = 37
///   inspect!(ptr[1], content="37")
///   free(ptr)
/// }
/// ```
pub fn Memory::of_bytes(bytes : Bytes) -> Memory[Byte] {
  let ptr = malloc(bytes.length())
  for i in 0..<bytes.length() {
    ptr[i] = bytes[i]
  }
  ptr
}

///| Generates a string from memory, doesn't free memory
pub fn Memory::to_string(self : Memory[Byte]) -> String {
  let length = self.length()
  let buffer = @buffer.new()
  for i = 0; i < length * 2; i = i + 1 {
    buffer.write_byte(self[i])
  }
  buffer.contents().to_unchecked_string()
}

///| Allocates memory for a string
pub fn Memory::of_string(string : String) -> Memory[Byte] {
  let ptr = malloc(string.length() * 2)
  let bytes = string.to_bytes()
  for i in 0..<bytes.length() {
    ptr[i] = bytes[i]
  }
  ptr
}

///| Pointer arithmetic addition
fn ptr_add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}

///| Pointer arithmetic addition
fn Memory::add[T : Sized](self : Memory[T], offset : Int) -> Memory[T] {
  let address = self._ + offset * T::size()
  Memory(address)
}
