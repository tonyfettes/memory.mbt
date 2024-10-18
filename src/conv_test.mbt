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
