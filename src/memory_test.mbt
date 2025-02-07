test "FixedArray[Byte]" {
  let bytes : FixedArray[FixedArray[Byte]] = [
    [b'h', b'e', b'l', b'l', b'o'],
    [b'w', b'o', b'r', b'l', b'd'],
    [b'f', b'o', b'o'],
    [b'b', b'a', b'r'],
    [b'b', b'a', b'z'],
    [b'q', b'u', b'x'],
  ]
  for b in bytes {
    let ptr = @memory.of_array(b)
    assert_eq!(ptr.to_array(), b)
    @memory.free(ptr)
  }
}

test "Bytes" {
  let bytes : FixedArray[Bytes] = [
    [b'h', b'e', b'l', b'l', b'o'],
    [b'w', b'o', b'r', b'l', b'd'],
    [b'f', b'o', b'o'],
    [b'b', b'a', b'r'],
    [b'b', b'a', b'z'],
    [b'q', b'u', b'x'],
  ]
  for b in bytes {
    let ptr = @memory.of_bytes(b)
    assert_eq!(ptr.to_bytes(), b)
    @memory.free(ptr)
  }
}

test "FixedArray[Int]" {
  let int_arrays : @builtin.Array[FixedArray[Int]] = @quickcheck.samples(10)
  for int_array in int_arrays {
    let ptr = @memory.of_array(int_array)
    assert_eq!(ptr.to_array(), int_array)
    @memory.free(ptr)
  }
}

test "FixedArray[UInt]" {
  let uint_arrays : @builtin.Array[FixedArray[UInt]] = @quickcheck.samples(10)
  for uint_array in uint_arrays {
    let ptr = @memory.of_array(uint_array)
    assert_eq!(ptr.to_array(), uint_array)
    @memory.free(ptr)
  }
}

test "FixedArray[Int64]" {
  let int64_arrays : @builtin.Array[FixedArray[Int64]] = @quickcheck.samples(10)
  for int64_array in int64_arrays {
    let ptr = @memory.of_array(int64_array)
    assert_eq!(ptr.to_array(), int64_array)
    @memory.free(ptr)
  }
}

test "FixedArray[UInt64]" {
  let uint64_arrays : @builtin.Array[FixedArray[UInt64]] = @quickcheck.samples(
    10,
  )
  for uint64_array in uint64_arrays {
    let ptr = @memory.of_array(uint64_array)
    assert_eq!(ptr.to_array(), uint64_array)
    @memory.free(ptr)
  }
}

test "FixedArray[Float]" {
  let int_arrays : @builtin.Array[FixedArray[Int]] = @quickcheck.samples(10)
  let float_arrays : @builtin.Array[FixedArray[Float]] = int_arrays.map(fn(
    array
  ) {
    array.map(fn(int) { int.reinterpret_as_float() })
  })
  for float_array in float_arrays {
    let ptr = @memory.of_array(float_array)
    assert_eq!(ptr.to_array(), float_array)
    @memory.free(ptr)
  }
}

test "FixedArray[Double]" {
  let int_arrays : @builtin.Array[FixedArray[Int64]] = @quickcheck.samples(10)
  let double_arrays : @builtin.Array[FixedArray[Double]] = int_arrays.map(fn(
    array
  ) {
    array.map(fn(int) { int.reinterpret_as_double() })
  })
  for double_array in double_arrays {
    let ptr = @memory.of_array(double_array)
    assert_eq!(ptr.to_array(), double_array)
    @memory.free(ptr)
  }
}
