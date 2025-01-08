///| Converts a string to a pointer suitable for WebAssembly memory.
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

///| Converts a pointer and length to a string.
///
/// Parameters:
///
/// - `ptr` : The integer pointer to the start of the string in memory.
/// - `len` : The length of the string in bytes.
///
/// Returns the string constructed from the memory pointed to by `ptr` with the
/// specified `len`.
pub fn ptr2str(ptr : Int, len : Int) -> String {
  let buf = @buffer.new()
  for i = 0; i < len * 2; i = i + 1 {
    buf.write_byte(load8_u(ptr + i).to_byte())
  }
  free(ptr)
  buf.contents().to_unchecked_string()
}

///| Converts a fixed-size byte array into a raw memory pointer by allocating
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

///| Converts a memory region pointed by a pointer into a fixed-size array of
/// bytes and frees the memory afterwards.
///
/// Parameters:
///
/// * `pointer` : An integer representing the memory address of the source data.
/// * `length` : The number of bytes to read from the memory address.
///
/// Returns a fixed-size array of bytes containing the data read from the memory
/// address.
pub fn ptr2byte_array(ptr : Int, len : Int) -> FixedArray[Byte] {
  let bytes = FixedArray::make(len, (0 : Byte))
  for i = 0; i < len; i = i + 1 {
    bytes[i] = load8_u(ptr + i).to_byte()
  }
  free(ptr)
  bytes
}

///| Converts a fixed array of unsigned integers to a pointer.
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

///| Converts a pointer and length to a fixed-size array of unsigned integers.
///
/// Parameters:
///
/// - `ptr` : The pointer to the memory location where the array data starts.
/// - `len` : The length of the array to be created.
///
/// Returns a `FixedArray[UInt]` containing the data from the specified memory
/// location.
pub fn ptr2uint_array(ptr : Int, len : Int) -> FixedArray[UInt] {
  let array : FixedArray[UInt] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4).reinterpret_as_uint()
  }
  free(ptr)
  array
}

///| Converts a fixed array of `UInt64` values to a pointer in WebAssembly memory.
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

///| Converts a pointer to an array of `UInt64` values. Sets the 64-bit header and
/// then retrieves the array from the pointer.
///
/// Parameters:
///
/// - `ptr` : The integer representing the pointer to the array.
/// - `len` : The length of the array. This parameter is currently unused in the
/// function.
///
/// Returns a `FixedArray[UInt64]` containing the values from the pointer.
pub fn ptr2uint64_array(ptr : Int, len : Int) -> FixedArray[UInt64] {
  let array : FixedArray[UInt64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8).reinterpret_as_uint64()
  }
  free(ptr)
  array
}

///| Converts a fixed-size integer array to a pointer.
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

///| Converts a pointer to an integer array in WebAssembly memory to a fixed-size
/// array of integers.
///
/// Parameters:
///
/// - `ptr` : The pointer to the start of the integer array in WebAssembly
/// memory.
/// - `len` : The length of the integer array.
///
/// Returns a `FixedArray[Int]` containing the integers from the specified memory
/// location.
pub fn ptr2int_array(ptr : Int, len : Int) -> FixedArray[Int] {
  let array : FixedArray[Int] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4)
  }
  free(ptr)
  array
}

///| Converts a fixed array of 64-bit integers to a pointer.
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

///| Converts a pointer to an array of 64-bit integers. Sets the 64-bit header
/// using an FFI call and then retrieves the array using another FFI call.
///
/// Parameters:
///
/// - `ptr` : The pointer to the memory location where the array starts.
/// - `len` : The length of the array. This parameter is currently unused in the
/// function.
///
/// Returns a `FixedArray[Int64]` containing the 64-bit integers from the memory
/// location pointed to by `ptr`.
pub fn ptr2int64_array(ptr : Int, len : Int) -> FixedArray[Int64] {
  let array : FixedArray[Int64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8)
  }
  free(ptr)
  array
}

///| Converts a fixed-size array of floats to a pointer in WebAssembly memory.
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

///| Converts a pointer to a WebAssembly memory buffer into a fixed-length array
/// of floating-point numbers.
///
/// Parameters:
///
/// - `ptr` : An integer representing the memory address of the buffer containing
/// the floating-point numbers.
/// - `len` : An integer representing the number of floating-point numbers in the
/// buffer.
///
/// Returns a `FixedArray[Float]` containing the floating-point numbers from the
/// specified memory buffer.
pub fn ptr2float_array(ptr : Int, len : Int) -> FixedArray[Float] {
  let array : FixedArray[Float] = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf32(ptr + i * 4)
  }
  free(ptr)
  array
}

///| Converts a fixed array of doubles to a pointer, adjusting the pointer by 8
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

///| Converts a pointer to a double array. Sets the 64-bit header and then
/// retrieves the double array gfrom the pointer.
///
/// Parameters:
///
/// - `ptr` : The integer pointer to the start of the double array.
/// - `len` : The length of the double array (unused in the function).
///
/// Returns a `FixedArray[Double]` containing the double values from the pointer.
pub fn ptr2double_array(ptr : Int, len : Int) -> FixedArray[Double] {
  let array = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf64(ptr + i * 8)
  }
  free(ptr)
  array
}
