/// Converts a string to a pointer suitable for WebAssembly memory.
///
/// Parameters:
///
/// - `str` : The string to be converted.
///
/// Returns the pointer to the string in WebAssembly memory.
pub extern "wasm" fn str2ptr(str : String) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

/// Converts a pointer and length to a string.
///
/// Parameters:
///
/// - `ptr` : The integer pointer to the start of the string in memory.
/// - `len` : The length of the string in bytes.
///
/// Returns the string constructed from the memory pointed to by `ptr` with the
/// specified `len`.
pub extern "wasm" fn ptr2str(ptr : Int, len : Int) -> String =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 243 i32.store8 local.get 0 i32.const 8 i32.sub)

/// Converts a fixed-size byte array into a raw memory pointer by allocating
/// memory and copying the bytes.
///
/// Parameters:
///
/// * `bytes`: A fixed-size array of bytes to be converted to a pointer.
///
/// Returns an integer representing the memory address (pointer) where the bytes
/// are stored.
pub extern "wasm" fn byte_array2ptr(bytes : FixedArray[Byte]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

/// Converts a memory region pointed by a pointer into a fixed-size array of
/// bytes and frees the memory afterwards.
///
/// Parameters:
///
/// * `pointer` : An integer representing the memory address of the source data.
/// * `length` : The number of bytes to read from the memory address.
///
/// Returns a fixed-size array of bytes containing the data read from the memory
/// address.
pub extern "wasm" fn ptr2byte_array(ptr : Int, len : Int) -> FixedArray[Byte] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

/// Converts a fixed array of unsigned integers to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed array of unsigned integers (`FixedArray[UInt]`).
///
/// Returns an integer representing the pointer to the array.
pub extern "wasm" fn uint_array2ptr(array : FixedArray[UInt]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

/// Converts a pointer and length to a fixed-size array of unsigned integers.
///
/// Parameters:
///
/// - `ptr` : The pointer to the memory location where the array data starts.
/// - `len` : The length of the array to be created.
///
/// Returns a `FixedArray[UInt]` containing the data from the specified memory
/// location.
pub extern "wasm" fn ptr2uint_array(ptr : Int, len : Int) -> FixedArray[UInt] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

/// Converts a fixed array of `UInt64` values to a pointer in WebAssembly memory.
///
/// Parameters:
///
/// - `array` : A fixed array of `UInt64` values to be converted.
///
/// Returns the pointer to the WebAssembly memory where the array is stored.
pub extern "wasm" fn uint64_array2ptr(array : FixedArray[UInt64]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

extern "wasm" fn ptr2uint64_array_ffi(ptr : Int) -> FixedArray[UInt64] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

/// Converts a pointer to an array of `UInt64` values. Sets the 64-bit header and
/// then retrieves the array from the pointer.
///
/// Parameters:
///
/// - `ptr` : The integer representing the pointer to the array.
/// - `len` : The length of the array. This parameter is currently unused in the
/// function.
///
/// Returns a `FixedArray[UInt64]` containing the values from the pointer.
pub fn ptr2uint64_array(ptr : Int, _len : Int) -> FixedArray[UInt64] {
  set_64_header_ffi(ptr - 4)
  ptr2uint64_array_ffi(ptr)
}

/// Converts a fixed-size integer array to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed-size array of integers (`FixedArray[Int]`).
///
/// Returns the pointer to the array as an integer.
pub extern "wasm" fn int_array2ptr(array : FixedArray[Int]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

/// Converts a pointer to an integer array in WebAssembly memory to a fixed-size
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
pub extern "wasm" fn ptr2int_array(ptr : Int, len : Int) -> FixedArray[Int] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

/// Converts a fixed array of 64-bit integers to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed array of 64-bit integers (`FixedArray[Int64]`).
///
/// Returns an integer representing the pointer to the array.
pub extern "wasm" fn int64_array2ptr(array : FixedArray[Int64]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

extern "wasm" fn ptr2int64_array_ffi(ptr : Int) -> FixedArray[Int64] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

/// Converts a pointer to an array of 64-bit integers. Sets the 64-bit header
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
pub fn ptr2int64_array(ptr : Int, _len : Int) -> FixedArray[Int64] {
  set_64_header_ffi(ptr - 4)
  ptr2int64_array_ffi(ptr)
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
pub extern "wasm" fn float_array2ptr(array : FixedArray[Float]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

/// Converts a pointer to a WebAssembly memory buffer into a fixed-length array
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
pub extern "wasm" fn ptr2float_array(ptr : Int, len : Int) -> FixedArray[Float] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

/// Converts a fixed array of doubles to a pointer, adjusting the pointer by 8
/// bytes.
///
/// Parameters:
///
/// - `array` : A fixed array of doubles (`FixedArray[Double]`).
///
/// Returns an integer representing the adjusted pointer.
pub extern "wasm" fn double_array2ptr(array : FixedArray[Double]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

extern "wasm" fn ptr2double_array_ffi(ptr : Int) -> FixedArray[Double] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

/// Converts a pointer to a double array. Sets the 64-bit header and then
/// retrieves the double array from the pointer.
///
/// Parameters:
///
/// - `ptr` : The integer pointer to the start of the double array.
/// - `len` : The length of the double array (unused in the function).
///
/// Returns a `FixedArray[Double]` containing the double values from the pointer.
pub fn ptr2double_array(ptr : Int, _len : Int) -> FixedArray[Double] {
  set_64_header_ffi(ptr - 4)
  ptr2double_array_ffi(ptr)
}

fn set_64_header_ffi(offset : Int) -> Unit {
  let len = load32(offset)
  store32(offset, len >> 1)
  store8(offset, 241)
}
