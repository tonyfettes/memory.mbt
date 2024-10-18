extern "wasm" fn malloc_inline(size : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 call $moonbit.gc.malloc)

pub fn malloc(size : Int) -> Int {
  let words = size / 4 + 1
  let address = malloc_inline(words * 4)
  // store32(address, 1)
  store32(address + 4, (words << 8) | 246)
  store8(address + words * 4 + 7, 3 - size % 4)
  address + 8
}

pub extern "wasm" fn free(position : Int) =
  #|(func (param i32) local.get 0 i32.const 8 i32.sub call $moonbit.decref)

pub fn copy(dest : Int, src : Int, len : Int) -> Unit {
  let src = src - 8
  let dst = dest - 8
  memory_copy(dst, src, len)
}

pub fn realloc(src : Int, dst_len : Int) -> Int {
  let dst = malloc(dst_len)
  let src_len = load32(src + 4) & 0xFFFFFF
  copy(dst, src, src_len)
  free(src)
  dst
}
