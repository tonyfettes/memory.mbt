extern "wasm" fn malloc_inline(size : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 call $moonbit.gc.malloc)

/// Allocates a block of memory of the specified size and returns the address of
/// the allocated memory.
///
/// Parameters:
///
/// - `size` : The size of the memory block to allocate, in bytes.
///
/// Returns the address of the allocated memory block.
pub fn malloc(size : Int) -> Int {
  let words = size / 4 + 1
  let address = malloc_inline(8 + words * 4)
  store32(address, 1)
  store32(address + 4, (words << 8) | 241)
  store8(address + words * 4 + 7, 3 - size % 4)
  address + 8
}

/// Frees the memory at the specified position by decrementing the reference
/// count.
///
/// Parameters:
///
/// - `position` : The integer position in memory to be freed.
pub extern "wasm" fn free(address : Int) =
  #|(func (param i32) local.get 0 i32.const 8 i32.sub call $moonbit.decref)

/// Copies a specified length of memory from the source address to the
/// destination address.
///
/// Parameters:
///
/// - `dest` : The destination memory address where the data will be copied to.
/// - `src` : The source memory address where the data will be copied from.
/// - `len` : The number of bytes to copy from the source to the destination.
///
/// Returns `Unit`, indicating that the function performs an action without
/// returning a value.
pub fn copy(dest : Int, src : Int, len : Int) -> Unit {
  let src = src - 8
  let dst = dest - 8
  memory_copy(dst, src, len)
}

/// Reallocate memory at the given `address` to the specified `size`.
///
/// Parameters:
///
/// - `address`: The memory address to reallocate.
/// - `size`: The new size for the memory block.
///
/// Returns the new memory address after reallocation.
pub fn realloc(address : Int, size : Int) -> Int {
  let dst = malloc(size)
  let src_len = load32(address + 4) & 0xFFFFFF
  copy(dst, address, src_len)
  free(address)
  dst
}
