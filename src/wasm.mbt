/// Extends a 32-bit signed integer to a 64-bit signed integer by sign-extending
/// the lower 16 bits.
///
/// Parameters:
///
/// - `value` : The 32-bit signed integer to be extended.
///
/// Returns the 64-bit signed integer resulting from the sign-extension of the
/// lower 16 bits of the input.
pub extern "wasm" fn extend16(value : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.extend16_s)

/// Extends a 32-bit integer to a 64-bit integer by sign-extending the lower 8
/// bits.
///
/// Parameters:
///
/// - `value` : The 32-bit integer to be extended.
///
/// Returns a 64-bit integer with the lower 8 bits sign-extended.
pub extern "wasm" fn extend8(value : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.extend8_s)

/// Stores a single byte at the specified memory offset in a WebAssembly memory.
///
/// Parameters:
///
/// - `offset` : The memory offset (in bytes) where the value will be stored.
/// - `value` : The integer value (0-255) to be stored as a byte at the specified
/// offset.
pub extern "wasm" fn store8(offset : Int, value : Int) =
  #|(func (param i32) (param i32) local.get 0 local.get 1 i32.store8)

/// Loads an unsigned 8-bit integer from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the unsigned 8-bit integer.
///
/// Returns the unsigned 8-bit integer value at the specified memory offset.
pub extern "wasm" fn load8_u(offset : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.load8_u)

/// Loads a signed 8-bit integer from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 8-bit integer.
///
/// Returns the signed 8-bit integer value at the specified memory offset.
pub extern "wasm" fn load8(offset : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.load8_s)

/// Stores a 16-bit integer value at a specified memory offset in WebAssembly
/// memory.
///
/// Parameters:
///
/// - `offset` : The memory offset where the value will be stored.
/// - `value` : The 16-bit integer value to be stored at the specified offset.
pub extern "wasm" fn store16(offset : Int, value : Int) =
  #|(func (param i32) (param i32) local.get 0 local.get 1 i32.store16)

/// Loads a 16-bit signed integer from memory at the specified `offset`.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 16-bit signed integer.
///
/// Returns the loaded 16-bit signed integer.
pub extern "wasm" fn load16(offset : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.load16_s)

/// Loads a 16-bit unsigned integer from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 16-bit unsigned
/// integer.
///
/// Returns the 16-bit unsigned integer loaded from memory.
pub extern "wasm" fn load16_u(offset : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.load16_u)

/// Stores a 32-bit integer value at a specified memory offset.
///
/// Parameters:
///
/// - `offset` : The memory offset where the value will be stored, represented as
/// an integer.
/// - `value` : The 32-bit integer value to be stored at the specified offset.
///
/// Returns nothing.
pub extern "wasm" fn store32(offset : Int, value : Int) =
  #|(func (param i32) (param i32) local.get 0 local.get 1 i32.store)

/// Loads a 32-bit integer from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 32-bit integer.
///
/// Returns the 32-bit integer loaded from memory at the specified offset.
pub extern "wasm" fn load32(offset : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.load)

/// Stores a 64-bit integer value at a specified memory offset in WebAssembly
/// memory.
///
/// Parameters:
///
/// - `offset` : The memory offset (in bytes) where the 64-bit integer will be
/// stored.
/// - `value` : The 64-bit integer value to be stored at the specified memory
/// offset.
pub extern "wasm" fn store64(offset : Int, value : Int64) =
  #|(func (param i32) (param i64) local.get 0 local.get 1 i64.store)

/// Loads a 64-bit integer from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 64-bit integer.
///
/// Returns the 64-bit integer loaded from memory at the given offset.
pub extern "wasm" fn load64(offset : Int) -> Int64 =
  #|(func (param i32) (result i64) local.get 0 i64.load)

/// Stores a 32-bit floating-point value at a specified memory offset in the
/// WebAssembly linear memory.
///
/// Parameters:
///
/// - `offset` : The memory offset (in bytes) where the 32-bit floating-point
/// value will be stored.
/// - `value` : The 32-bit floating-point value to be stored at the specified
/// memory offset.
pub extern "wasm" fn storef32(offset : Int, value : Float) =
  #|(func (param i32) (param f32) local.get 0 local.get 1 f32.store)

/// Loads a 32-bit floating-point number from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset from which to load the 32-bit floating-point
/// number.
///
/// Returns the 32-bit floating-point number loaded from memory.
pub extern "wasm" fn loadf32(offset : Int) -> Float =
  #|(func (param i32) (result f32) local.get 0 f32.load)

/// Stores a 64-bit floating-point value at a specified memory offset in
/// WebAssembly memory.
///
/// Parameters:
///
/// - `offset` : The memory offset (in bytes) where the 64-bit floating-point
/// value will be stored.
/// - `value` : The 64-bit floating-point value to be stored at the specified
/// memory offset.
///
/// Returns nothing.
pub extern "wasm" fn storef64(offset : Int, value : Double) =
  #|(func (param i32) (param f64) local.get 0 local.get 1 f64.store)

/// Loads a 64-bit floating-point number from memory at the specified offset.
///
/// Parameters:
///
/// - `offset` : The memory offset (in bytes) from which to load the 64-bit
/// floating-point number.
///
/// Returns the 64-bit floating-point number loaded from memory.
pub extern "wasm" fn loadf64(offset : Int) -> Double =
  #|(func (param i32) (result f64) local.get 0 f64.load)

/// Converts a 32-bit floating-point number to a 32-bit signed integer.
///
/// Parameters:
///
/// - `value` : The 32-bit floating-point number to be converted.
///
/// Returns the 32-bit signed integer representation of the input floating-point
/// number.
pub extern "wasm" fn f32_to_i32(value : Float) -> Int =
  #|(func (param f32) (result i32) local.get 0 f32.convert_i32_s)

/// Converts a 32-bit floating-point number to a 64-bit signed integer.
///
/// Parameters:
///
/// - `value` : A 32-bit floating-point number to be converted.
///
/// Returns a 64-bit signed integer.
pub extern "wasm" fn f32_to_i64(value : Float) -> Int64 =
  #|(func (param f32) (result i64) local.get 0 f32.convert_i64_s)

/// Copies a block of memory from one location to another in the WebAssembly
/// memory.
///
/// Parameters:
///
/// - `dest` : The destination memory address where the data will be copied to.
/// - `src` : The source memory address where the data will be copied from.
/// - `len` : The number of bytes to copy from the source to the destination.
extern "wasm" fn memory_copy(dest : Int, src : Int, len : Int) =
  #|(func (param i32) (param i32) (param i32) local.get 0 local.get 1 local.get 2 memory.copy)
