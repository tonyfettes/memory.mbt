test "str2ptr - ptr2str" {
  let strings : Array[String] = @quickcheck.samples(10)
  for str in strings {
    let ptr = @memory.str2ptr(str)
    assert_eq!(@memory.ptr2str(ptr, str.length()), str)
  }
}

test "bytes2ptr - ptr2bytes" {
  let bytes : FixedArray[Bytes] = [
    b"hello", b"world", b"foo", b"bar", b"baz", b"qux",
  ]
  for b in bytes {
    let ptr = @memory.bytes2ptr(b)
    assert_eq!(@memory.ptr2bytes(ptr, b.length()), b)
  }
}

test "FixedArray[Int]" {
  let int_arrays : Array[FixedArray[Int]] = @quickcheck.samples(10)
  for int_array in int_arrays {
    let ptr = @memory.int_array2ptr(int_array)
    assert_eq!(@memory.ptr2int_array(ptr, int_array.length()), int_array)
  }
}

test "FixedArray[UInt]" {
  let uint_arrays : Array[FixedArray[UInt]] = @quickcheck.samples(10)
  for uint_array in uint_arrays {
    let ptr = @memory.uint_array2ptr(uint_array)
    assert_eq!(@memory.ptr2uint_array(ptr, uint_array.length()), uint_array)
  }
}

test "FixedArray[Int64]" {
  let int64_arrays : Array[FixedArray[Int64]] = @quickcheck.samples(10)
  for int64_array in int64_arrays {
    let ptr = @memory.int64_array2ptr(int64_array)
    assert_eq!(@memory.ptr2int64_array(ptr, int64_array.length()), int64_array)
  }
}

test "FixedArray[UInt64]" {
  let uint64_arrays : Array[FixedArray[UInt64]] = @quickcheck.samples(10)
  for uint64_array in uint64_arrays {
    let ptr = @memory.uint64_array2ptr(uint64_array)
    assert_eq!(@memory.ptr2uint64_array(ptr, uint64_array.length()), uint64_array)
  }
}

test "FixedArray[Float]" {
  let int_arrays : Array[FixedArray[Int]] = @quickcheck.samples(10)
  let float_arrays : Array[FixedArray[Float]] = int_arrays.map(fn(array) {
    array.map(fn(int) { int.reinterpret_as_float() })
  })
  for float_array in float_arrays {
    let ptr = @memory.float_array2ptr(float_array)
    assert_eq!(@memory.ptr2float_array(ptr, float_array.length()), float_array)
  }
}


test "FixedArray[Double]" {
  let int_arrays : Array[FixedArray[Int64]] = @quickcheck.samples(10)
  let double_arrays : Array[FixedArray[Double]] = int_arrays.map(fn(array) {
    array.map(fn(int) { int.reinterpret_as_double() })
  })
  for double_array in double_arrays {
    let ptr = @memory.double_array2ptr(double_array)
    assert_eq!(@memory.ptr2double_array(ptr, double_array.length()), double_array)
  }
}