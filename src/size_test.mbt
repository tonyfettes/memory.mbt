test "size" {
  inspect!(@memory.sizeof(@memory.byte), content="1")
  inspect!(@memory.sizeof(@memory.int), content="4")
  inspect!(@memory.sizeof(@memory.uint), content="4")
  inspect!(@memory.sizeof(@memory.int64), content="8")
  inspect!(@memory.sizeof(@memory.uint64), content="8")
  inspect!(@memory.sizeof(@memory.float), content="4")
}

test "size/array" {
  inspect!(@memory.sizeof(@memory.byte[10]), content="10")
  inspect!(@memory.sizeof(@memory.int[4]), content="16")
}
