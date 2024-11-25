/// Converts a string to a pointer suitable for WebAssembly memory.
///
/// Parameters:
///
/// - `str` : The string to be converted.
///
/// Returns the pointer to the string in WebAssembly memory.
pub extern "wasm" fn str2ptr(str : String) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2str(ptr : Int) -> String =
  #|(func (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 243 i32.store8 local.get 0 i32.const 8 i32.sub)

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

pub extern "wasm" fn ptr2byte_array(ptr : Int) -> FixedArray[Byte] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

/// Converts a fixed array of unsigned integers to a pointer.
///
/// Parameters:
///
/// - `array` : A fixed array of unsigned integers (`FixedArray[UInt]`).
///
/// Returns an integer representing the pointer to the array.
pub extern "wasm" fn uint_array2ptr(array : FixedArray[UInt]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2uint_array(ptr : Int) -> FixedArray[UInt] =
  #|(func (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

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

pub fn ptr2uint64_array(ptr : Int) -> FixedArray[UInt64] {
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

pub extern "wasm" fn ptr2int_array(ptr : Int) -> FixedArray[Int] =
  #|(func (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

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

pub fn ptr2int64_array(ptr : Int) -> FixedArray[Int64] {
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

pub extern "wasm" fn ptr2float_array(ptr : Int) -> FixedArray[Float] =
  #|(func (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

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

pub fn ptr2double_array(ptr : Int) -> FixedArray[Double] {
  set_64_header_ffi(ptr - 4)
  ptr2double_array_ffi(ptr)
}

fn set_64_header_ffi(offset : Int) -> Unit {
  let len = load32(offset)
  store32(offset, len >> 1)
  store8(offset, 241)
}
