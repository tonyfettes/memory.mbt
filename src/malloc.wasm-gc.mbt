///|
let allocator : Allocator = Allocator::new()

///|
pub fn malloc[T : Sized](size : Int) -> Memory[T] {
  allocator.allocate(size * T::size())
}

///|
pub fn free[T](ptr : Memory[T]) -> Unit {
  allocator.deallocate(ptr._)
}

///|
pub fn realloc[T : Sized](ptr : Memory[T], size : Int) -> Memory[T] {
  allocator.reallocate(ptr._, size * T::size())
}
