///|
pub impl Set for Byte with set(ptr : Memory[Byte], index : Int, value : Byte) -> Unit {
  @wasm.i32_store8(ptr.add(index)._, value.to_int())
}

///|
pub impl Set for Int16 with set(ptr : Memory[Int16], index : Int, value : Int16) -> Unit {
  @wasm.i32_store16(ptr.add(index)._, value.to_int())
}

///|
pub impl Set for UInt16 with set(
  ptr : Memory[UInt16],
  index : Int,
  value : UInt16
) -> Unit {
  @wasm.i32_store16(ptr.add(index)._, value.to_int())
}

///|
pub impl Set for Int with set(ptr : Memory[Int], index : Int, value : Int) -> Unit {
  @wasm.i32_store(ptr.add(index)._, value)
}

///|
pub impl Set for UInt with set(ptr : Memory[UInt], index : Int, value : UInt) -> Unit {
  @wasm.i32_store(ptr.add(index)._, value.reinterpret_as_int())
}

///|
pub impl Set for Int64 with set(ptr : Memory[Int64], index : Int, value : Int64) -> Unit {
  @wasm.i64_store(ptr.add(index)._, value)
}

///|
pub impl Set for UInt64 with set(
  ptr : Memory[UInt64],
  index : Int,
  value : UInt64
) -> Unit {
  @wasm.i64_store(ptr.add(index)._, value.reinterpret_as_int64())
}

///|
pub impl Set for Float with set(ptr : Memory[Float], index : Int, value : Float) -> Unit {
  @wasm.f32_store(ptr.add(index)._, value)
}

///|
pub impl Set for Double with set(
  ptr : Memory[Double],
  index : Int,
  value : Double
) -> Unit {
  @wasm.f64_store(ptr.add(index)._, value)
}
