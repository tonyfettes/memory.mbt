///|
pub fn Memory::op_get[T : Sized + Get](self : Memory[T], index : Int) -> T {
  T::get(self, index)
}

///|
pub fn Memory::op_set[T : Sized + Set](
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
pub fn Memory::get[T : Get](self : Memory[T], index : Int) -> T {
  T::get(self, index)
}

///|
trait Set {
  set(Memory[Self], Int, Self) -> Unit
}

///|
pub fn Memory::set[T : Set](self : Memory[T], index : Int, value : T) -> Unit {
  T::set(self, index, value)
}
