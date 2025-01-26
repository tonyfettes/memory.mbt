///|
pub impl Get for Byte with get(self : Memory[Byte], index : Int) -> Byte {
  self.to_array()[index]
}

///|
pub impl Get for Int with get(self : Memory[Int], index : Int) -> Int {
  self.to_array()[index]
}

///|
pub impl Get for UInt with get(self : Memory[UInt], index : Int) -> UInt {
  self.to_array()[index]
}

///|
pub impl Get for Int64 with get(self : Memory[Int64], index : Int) -> Int64 {
  self.to_array()[index]
}

///|
pub impl Get for UInt64 with get(self : Memory[UInt64], index : Int) -> UInt64 {
  self.to_array()[index]
}

///|
pub impl Get for Float with get(self : Memory[Float], index : Int) -> Float {
  self.to_array()[index]
}

///|
pub impl Get for Double with get(self : Memory[Double], index : Int) -> Double {
  self.to_array()[index]
}
