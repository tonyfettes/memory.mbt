test "size" {
  inspect!(@memory.sizeof(@memory.byte), content="1")
  inspect!(@memory.sizeof(@memory.int_), content="4")
  inspect!(@memory.sizeof(@memory.uint), content="4")
  inspect!(@memory.sizeof(@memory.int64), content="8")
  inspect!(@memory.sizeof(@memory.uint64), content="8")
  inspect!(@memory.sizeof(@memory.float_), content="4")
}

test "size/array" {
  inspect!(@memory.sizeof(@memory.byte[10]), content="10")
  inspect!(@memory.sizeof(@memory.int_[4]), content="16")
  inspect!(@memory.sizeof(@memory.uint[2]), content="8")
  inspect!(@memory.sizeof(@memory.int64[4]), content="32")
  inspect!(@memory.sizeof(@memory.uint64[5]), content="40")
  inspect!(@memory.sizeof(@memory.float_[4]), content="16")
  inspect!(@memory.sizeof(@memory.double_[8]), content="64")
}
