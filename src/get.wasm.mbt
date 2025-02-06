///|
pub impl Get for Byte with get(self : Memory[Byte], index : Int) -> Byte {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for Int with get(self : Memory[Int], index : Int) -> Int {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for UInt with get(self : Memory[UInt], index : Int) -> UInt {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for Int64 with get(self : Memory[Int64], index : Int) -> Int64 {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for UInt64 with get(self : Memory[UInt64], index : Int) -> UInt64 {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for Float with get(self : Memory[Float], index : Int) -> Float {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}

///|
pub impl Get for Double with get(self : Memory[Double], index : Int) -> Double {
  let array = self.to_array()
  let value = array.unsafe_get(index)
  value
}
