///|
let allocator : Allocator = Allocator::new()

///|
/// Allocates a block of memory with the given size and element type.
///
/// Parameters:
///
/// * `size` : The number of elements to allocate.
/// * `T` : The type of elements to be stored in the memory block. Must implement
/// `Sized`, `Default`, and `Set` traits.
///
/// Returns a `Memory[T]` pointer to the allocated memory block.
///
/// Example:
///
/// ```moonbit
/// test "malloc" {
///   let ptr : Memory[Int] = malloc(4)
///   inspect!(ptr.length(), content="4")
///   free(ptr)
/// }
/// ```
pub fn[T : Sized + Default + Set] malloc(size : Int) -> Memory[T] {
  allocator.allocate(size * T::size())
}

///|
/// Deallocates a block of memory previously allocated by `malloc` or `realloc`.
/// After calling this function, the memory block pointed to by the pointer
/// becomes invalid and should not be accessed.
///
/// Parameters:
///
/// * `pointer` : A pointer to the memory block to be deallocated. The pointer
/// must be a valid pointer previously returned by `malloc` or `realloc`.
///
/// Example:
///
/// ```moonbit
/// test "free" {
///   let ptr : Memory[Int] = malloc(4)
///   free(ptr)
/// }
/// ```
pub fn[T] free(ptr : Memory[T]) -> Unit {
  allocator.deallocate(ptr._)
}

///|
pub fn[T : Sized + Get + Set] blit(
  dst : Memory[T],
  dst_offset : Int,
  src : Memory[T],
  src_offset : Int,
  len : Int
) -> Unit {
  for i in 0..<len {
    dst[dst_offset + i] = src[src_offset + i]
  }
}

///|
/// Reallocates a block of memory with a new size, preserving its contents. If
/// the new size is larger than the current size, the additional memory is
/// uninitialized. If the new size is smaller, the memory block is truncated.
///
/// Parameters:
///
/// * `pointer` : A pointer to the memory block to be reallocated. Must be a
/// valid pointer previously returned by `malloc` or `realloc`.
/// * `size` : The new number of elements to allocate. Must be non-negative.
///
/// Returns a pointer to the newly allocated memory block. The contents of the
/// original memory block are copied to the new block.
///
/// Example:
///
/// ```moonbit
/// test "realloc" {
///   let ptr : Memory[Int] = malloc(2)
///   ptr[0] = 42
///   ptr[1] = 37
///   let new_ptr = realloc(ptr, 4)
///   inspect!(new_ptr[0], content="42")
///   inspect!(new_ptr[1], content="37")
///   free(new_ptr)
/// }
/// ```
pub fn[T : Sized + Default + Get + Set] realloc(
  ptr : Memory[T],
  size : Int
) -> Memory[T] {
  allocator.reallocate(ptr._, size * T::size())
}
