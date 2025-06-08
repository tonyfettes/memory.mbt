///|
/// Retrieves an element at the specified index from a memory block.
///
/// Parameters:
///
/// * `self` : A pointer to the memory block.
/// * `index` : The position of the element to retrieve.
///
/// Returns the element at the specified index with type `T`.
///
/// Example:
///
/// ```moonbit
/// test "Memory::op_get" {
///   let ptr : Memory[Int] = malloc(2)
///   ptr[0] = 42
///   inspect!(ptr[0], content="42")
///   free(ptr)
/// }
/// ```
pub fn[T : Sized + Get] Memory::op_get(self : Memory[T], index : Int) -> T {
  T::get(self, index)
}

///|
/// Sets a value at the specified index in the memory block. This method
/// implements the operator `[_] = _`, allowing users to write `ptr[index] =
/// value` instead of calling this method directly.
///
/// Parameters:
///
/// * `self` : The pointer to the memory block.
/// * `index` : The position where the value should be stored.
/// * `value` : The value to be stored in the memory block.
///
/// Example:
///
/// ```moonbit
/// test "Memory::op_set" {
///   let ptr : Memory[Int] = malloc(2)
///   ptr[0] = 42
///   inspect!(ptr[0], content="42")
///   free(ptr)
/// }
/// ```
pub fn[T : Sized + Set] Memory::op_set(
  self : Memory[T],
  index : Int,
  value : T
) -> Unit {
  T::set(self, index, value)
}

///|
trait Get {
  get(Memory[Self], Int) -> Self
}

///|
/// Retrieves an element at the specified index from a memory block.
///
/// Parameters:
///
/// * `self` : A pointer to the memory block.
/// * `index` : The position of the element to retrieve.
///
/// Returns the element at the specified index with type `T`.
///
/// Example:
///
/// ```moonbit
/// test "Memory::get" {
///   let ptr : Memory[Int] = malloc(2)
///   ptr[0] = 42
///   inspect!(ptr.get(0), content="42")
///   free(ptr)
/// }
/// ```
pub fn[T : Get] Memory::get(self : Memory[T], index : Int) -> T {
  T::get(self, index)
}

///|
trait Set {
  set(Memory[Self], Int, Self) -> Unit
}

///|
/// Sets a value at the specified index in a memory block.
///
/// Parameters:
///
/// * `self` : A pointer to the memory block.
/// * `index` : The position where the value should be stored.
/// * `value` : The value to be written at the specified position.
///
/// Example:
///
/// ```moonbit
/// test "Memory::set" {
///   let ptr : Memory[Int] = malloc(2)
///   ptr.set(0, 42)
///   inspect!(ptr[0], content="42")
///   free(ptr)
/// }
/// ```
pub fn[T : Set] Memory::set(self : Memory[T], index : Int, value : T) -> Unit {
  T::set(self, index, value)
}

///|
fn[T] _array_unsafe_set(array : FixedArray[T], index : Int, value : T) -> Unit = "%fixedarray.unsafe_set"
