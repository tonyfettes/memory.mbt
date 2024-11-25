/// Converts a string to a pointer suitable for WebAssembly memory.
///
/// Parameters:
///
/// - `str` : The string to be converted.
///
/// Returns the pointer to the string in WebAssembly memory.
pub fn str2ptr(str : String) -> Int {
  let ptr = malloc(str.length() * 2)
  let bytes = str.to_bytes()
  for i in 0..<bytes.length() {
    store8(ptr + i, bytes[i].to_int())
  }
  ptr
}

pub fn ptr2str(ptr : Int) -> String {
  if ptr == empty_block {
    return ""
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size
  let buf = @buffer.new()
  for i = 0; i < len; i = i + 1 {
    buf.write_byte(load8_u(ptr + i).to_byte())
  }
  free(ptr)
  buf.to_unchecked_string()
}

/// Converts a fixed-size byte array into a raw memory pointer by allocating
/// memory and copying the bytes.
///
/// Parameters:
///
/// * `bytes`: A fixed-size array of bytes to be converted to a pointer.
///
/// Returns an integer representing the memory address (pointer) where the bytes
/// are stored.
pub fn byte_array2ptr(bytes : FixedArray[Byte]) -> Int {
  let ptr = malloc(bytes.length())
  for i = 0; i < bytes.length(); i = i + 1 {
    store8(ptr + i, bytes[i].to_int())
  }
  ptr
}

/// Converts a memory region pointed by a pointer into a fixed-size array of
/// bytes and frees the memory afterwards.
///
/// Parameters:
///
/// * `pointer` : An integer representing the memory address of the source data.
///
/// Returns a fixed-size array of bytes containing the data read from the memory
/// address.
pub fn ptr2byte_array(ptr : Int) -> FixedArray[Byte] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size
  let bytes = FixedArray::make(len, (0 : Byte))
  for i = 0; i < len; i = i + 1 {
    bytes[i] = load8_u(ptr + i).to_byte()
  }
  free(ptr)
  bytes
}

/// Converts a fixed array of unsigned integers to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed array of unsigned integers (`FixedArray[UInt]`).
///
/// Returns an integer representing the pointer to the array.
pub fn uint_array2ptr(array : FixedArray[UInt]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    store32(ptr + i * 4, array[i].reinterpret_as_int())
  }
  ptr
}

pub fn ptr2uint_array(ptr : Int) -> FixedArray[UInt] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 4
  let array : FixedArray[UInt] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4).reinterpret_as_uint()
  }
  free(ptr)
  array
}

/// Converts a fixed array of `UInt64` values to a pointer in WebAssembly memory.
///
/// Parameters:
///
/// - `array` : A fixed array of `UInt64` values to be converted.
///
/// Returns the pointer to the WebAssembly memory where the array is stored.
pub fn uint64_array2ptr(array : FixedArray[UInt64]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    store64(ptr + i * 8, array[i].reinterpret_as_int64())
  }
  ptr
}

pub fn ptr2uint64_array(ptr : Int) -> FixedArray[UInt64] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 8
  let array : FixedArray[UInt64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8).reinterpret_as_uint64()
  }
  free(ptr)
  array
}

/// Converts a fixed-size integer array to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed-size array of integers (`FixedArray[Int]`).
///
/// Returns the pointer to the array as an integer.
pub fn int_array2ptr(array : FixedArray[Int]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    store32(ptr + i * 4, array[i])
  }
  ptr
}

/// Converts a memory block pointed by a pointer into a fixed-size array of
/// integers. Frees the memory block after conversion.
///
/// Parameters:
///
/// * `pointer`: Memory address pointing to a block of contiguous memory containing
/// 32-bit integers.
///
/// Returns a fixed-size array containing the integers read from the memory
/// block. The size of the array is determined by the block size divided by 4 (as
/// each integer occupies 4 bytes).
pub fn ptr2int_array(ptr : Int) -> FixedArray[Int] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 4
  let array : FixedArray[Int] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4)
  }
  free(ptr)
  array
}

/// Converts a fixed array of 64-bit integers to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed array of 64-bit integers (`FixedArray[Int64]`).
///
/// Returns an integer representing the pointer to the array.
pub fn int64_array2ptr(array : FixedArray[Int64]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    store64(ptr + i * 8, array[i])
  }
  ptr
}

pub fn ptr2int64_array(ptr : Int) -> FixedArray[Int64] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 8
  let array : FixedArray[Int64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8)
  }
  free(ptr)
  array
}

/// Converts a fixed-size array of floats to a pointer in WebAssembly memory.
///
/// Parameters:
///
/// - `array` : A fixed-size array of floats (`FixedArray[Float]`) to be
/// converted.
///
/// Returns an integer representing the pointer to the array in WebAssembly
/// memory.
pub fn float_array2ptr(array : FixedArray[Float]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    storef32(ptr + i * 4, array[i])
  }
  ptr
}

pub fn ptr2float_array(ptr : Int) -> FixedArray[Float] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 4
  let array : FixedArray[Float] = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf32(ptr + i * 4)
  }
  free(ptr)
  array
}

/// Converts a fixed array of doubles to a pointer, adjusting the pointer by 8
/// bytes.
///
/// Parameters:
///
/// - `array` : A fixed array of doubles (`FixedArray[Double]`).
///
/// Returns an integer representing the adjusted pointer.
pub fn double_array2ptr(array : FixedArray[Double]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    storef64(ptr + i * 8, array[i])
  }
  ptr
}

pub fn ptr2double_array(ptr : Int) -> FixedArray[Double] {
  if ptr == empty_block {
    return []
  }
  let block = manager.blocks[manager.search_block(ptr)]
  let len = block.size / 8
  let array = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf64(ptr + i * 8)
  }
  free(ptr)
  array
}
