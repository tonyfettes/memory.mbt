///|
pub impl Get for Byte with get(ptr : Memory[Byte], index : Int) -> Byte {
  @wasm.i32_load8_u(ptr.add(index)._).to_byte()
}

///|
pub impl Get for Int16 with get(ptr : Memory[Int16], index : Int) -> Int16 {
  @wasm.i32_load16_s(ptr.add(index)._).to_int16()
}

///|
pub impl Get for UInt16 with get(ptr : Memory[UInt16], index : Int) -> UInt16 {
  @wasm.i32_load16_u(ptr.add(index)._).to_uint16()
}

///|
pub impl Get for Int with get(ptr : Memory[Int], index : Int) -> Int {
  @wasm.i32_load(ptr.add(index)._)
}

///|
pub impl Get for UInt with get(ptr : Memory[UInt], index : Int) -> UInt {
  @wasm.i32_load(ptr.add(index)._).reinterpret_as_uint()
}

///|
pub impl Get for Int64 with get(ptr : Memory[Int64], index : Int) -> Int64 {
  @wasm.i64_load(ptr.add(index)._)
}

///|
pub impl Get for UInt64 with get(ptr : Memory[UInt64], index : Int) -> UInt64 {
  @wasm.i64_load(ptr.add(index)._).reinterpret_as_uint64()
}

///|
pub impl Get for Float with get(ptr : Memory[Float], index : Int) -> Float {
  @wasm.f32_load(ptr.add(index)._)
}

///|
pub impl Get for Double with get(ptr : Memory[Double], index : Int) -> Double {
  @wasm.f64_load(ptr.add(index)._)
}
