pub fn str2ptr(str : String) -> Int {
  let ptr = malloc(str.length() * 2)
  let bytes = str.to_bytes()
  for i in 0..<bytes.length() {
    store8(ptr + i, bytes[i].to_int())
  }
  ptr
}

pub fn ptr2str(ptr : Int, len : Int) -> String {
  let buf = @buffer.Buffer::new()
  for i = 0; i < len * 2; i = i + 1 {
    buf.write_byte(load8_u(ptr + i).to_byte())
  }
  free(ptr)
  buf.to_string()
}

pub fn bytes2ptr(bytes : Bytes) -> Int {
  let ptr = malloc(bytes.length())
  for i = 0; i < bytes.length(); i = i + 1 {
    store8(ptr + i, bytes[i].to_int())
  }
  ptr
}

pub fn ptr2bytes(ptr : Int, len : Int) -> Bytes {
  let bytes = Bytes::new(len)
  for i = 0; i < len; i = i + 1 {
    bytes[i] = load8_u(ptr + i).to_byte()
  }
  free(ptr)
  bytes
}

pub fn uint_array2ptr(array : FixedArray[UInt]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    store32(ptr + i * 4, array[i].reinterpret_as_int())
  }
  ptr
}

pub fn ptr2uint_array(ptr : Int, len : Int) -> FixedArray[UInt] {
  let array : FixedArray[UInt] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4).reinterpret_as_uint()
  }
  free(ptr)
  array
}

pub fn uint64_array2ptr(array : FixedArray[UInt64]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    store64(ptr + i * 8, array[i].reinterpret_as_int64())
  }
  ptr
}

pub fn ptr2uint64_array(ptr : Int, len : Int) -> FixedArray[UInt64] {
  let array : FixedArray[UInt64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8).reinterpret_as_uint64()
  }
  free(ptr)
  array
}

pub fn int_array2ptr(array : FixedArray[Int]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    store32(ptr + i * 4, array[i])
  }
  ptr
}

pub fn ptr2int_array(ptr : Int, len : Int) -> FixedArray[Int] {
  let array : FixedArray[Int] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load32(ptr + i * 4)
  }
  free(ptr)
  array
}

pub fn int64_array2ptr(array : FixedArray[Int64]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    store64(ptr + i * 8, array[i])
  }
  ptr
}

pub fn ptr2int64_array(ptr : Int, len : Int) -> FixedArray[Int64] {
  let array : FixedArray[Int64] = FixedArray::make(len, 0)
  for i = 0; i < len; i = i + 1 {
    array[i] = load64(ptr + i * 8)
  }
  free(ptr)
  array
}

pub fn float_array2ptr(array : FixedArray[Float]) -> Int {
  let ptr = malloc(array.length() * 4)
  for i = 0; i < array.length(); i = i + 1 {
    storef32(ptr + i * 4, array[i])
  }
  ptr
}

pub fn ptr2float_array(ptr : Int, len : Int) -> FixedArray[Float] {
  let array : FixedArray[Float] = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf32(ptr + i * 4)
  }
  free(ptr)
  array
}

pub fn double_array2ptr(array : FixedArray[Double]) -> Int {
  let ptr = malloc(array.length() * 8)
  for i = 0; i < array.length(); i = i + 1 {
    storef64(ptr + i * 8, array[i])
  }
  ptr
}

pub fn ptr2double_array(ptr : Int, len : Int) -> FixedArray[Double] {
  let array = FixedArray::make(len, 0.0)
  for i = 0; i < len; i = i + 1 {
    array[i] = loadf64(ptr + i * 8)
  }
  free(ptr)
  array
}
