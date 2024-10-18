pub extern "wasm" fn str2ptr(str : String) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2str(ptr : Int, len : Int) -> String =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 243 i32.store8 local.get 0 i32.const 8 i32.sub)

pub extern "wasm" fn bytes2ptr(bytes : Bytes) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2bytes(ptr : Int, len : Int) -> Bytes =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

pub extern "wasm" fn uint_array2ptr(array : FixedArray[UInt]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2uint_array(ptr : Int, len : Int) -> FixedArray[UInt] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

pub extern "wasm" fn uint64_array2ptr(array : FixedArray[UInt64]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn int_array2ptr(array : FixedArray[Int]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2int_array(ptr : Int, len : Int) -> FixedArray[Int] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

pub extern "wasm" fn int64_array2ptr(array : FixedArray[Int64]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn float_array2ptr(array : FixedArray[Float]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

pub extern "wasm" fn ptr2float_array(ptr : Int, len : Int) -> FixedArray[Float] =
  #|(func (param i32) (param i32) (result i32) local.get 0 i32.const 4 i32.sub i32.const 241 i32.store8 local.get 0 i32.const 8 i32.sub)

pub extern "wasm" fn double_array2ptr(array : FixedArray[Double]) -> Int =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.add)

extern "wasm" fn ptr2uint64_array_ffi(ptr : Int) -> FixedArray[UInt64] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

pub fn ptr2uint64_array(ptr : Int, _len : Int) -> FixedArray[UInt64] {
  set_64_header_ffi(ptr - 4)
  ptr2uint64_array_ffi(ptr)
}

extern "wasm" fn ptr2int64_array_ffi(ptr : Int) -> FixedArray[Int64] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

pub fn ptr2int64_array(ptr : Int, _len : Int) -> FixedArray[Int64] {
  set_64_header_ffi(ptr - 4)
  ptr2int64_array_ffi(ptr)
}

extern "wasm" fn ptr2double_array_ffi(ptr : Int) -> FixedArray[Double] =
  #|(func (param i32) (result i32) local.get 0 i32.const 8 i32.sub)

pub fn ptr2double_array(ptr : Int, _len : Int) -> FixedArray[Double] {
  set_64_header_ffi(ptr - 4)
  ptr2double_array_ffi(ptr)
}

fn set_64_header_ffi(offset : Int) -> Unit {
  let len = load32(offset)
  store32(offset, len >> 1)
  store8(offset, 241)
}
