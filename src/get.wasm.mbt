///|
pub impl Get for Byte with get(self : Memory[Byte], index : Int) -> Byte {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

  value
}

///|
pub impl Get for Int with get(self : Memory[Int], index : Int) -> Int {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

///|
pub impl Get for UInt with get(self : Memory[UInt], index : Int) -> UInt {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

///|
pub impl Get for Int64 with get(self : Memory[Int64], index : Int) -> Int64 {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

///|
pub impl Get for UInt64 with get(self : Memory[UInt64], index : Int) -> UInt64 {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

///|
pub impl Get for Float with get(self : Memory[Float], index : Int) -> Float {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}

///|
pub impl Get for Double with get(self : Memory[Double], index : Int) -> Double {
  let array = self.as_array()
  let value = array.unsafe_get(index)
  _array_incref(array)
  value
}
