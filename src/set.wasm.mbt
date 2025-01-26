///|
pub impl Set for Byte with set(self : Memory[Byte], index : Int, value : Byte) -> Unit {
  self.to_array()[index] = value
}

///|
pub impl Set for Int with set(self : Memory[Int], index : Int, value : Int) -> Unit {
  self.to_array()[index] = value
}

///|
pub impl Set for UInt with set(self : Memory[UInt], index : Int, value : UInt) -> Unit {
  self.to_array()[index] = value
}

///|
pub impl Set for Int64 with set(
  self : Memory[Int64],
  index : Int,
  value : Int64
) -> Unit {
  let array = self.to_array()
  array[index] = value
}

///|
pub impl Set for UInt64 with set(
  self : Memory[UInt64],
  index : Int,
  value : UInt64
) -> Unit {
  let array = self.to_array()
  array[index] = value
}

///|
pub impl Set for Float with set(
  self : Memory[Float],
  index : Int,
  value : Float
) -> Unit {
  let array = self.to_array()
  array[index] = value
}

///|
pub impl Set for Double with set(
  self : Memory[Double],
  index : Int,
  value : Double
) -> Unit {
  self.to_array()[index] = value
}
