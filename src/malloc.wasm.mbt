extern "wasm" fn malloc_inline(size : Int) -> Int =
  #|(func (param i32) (result i32) local.get 0 call $moonbit.malloc)

pub fn malloc(size : Int) -> Int {
  let words = size / 4 + 1
  let address = malloc_inline(8 + words * 4)
  store32(address, 1)
  store32(address + 4, (words << 8) | 246)
  store8(address + words * 4 + 7, 3 - size % 4)
  address + 8
}

pub extern "wasm" fn free(position : Int) =
  #|(func (param i32) local.get 0 i32.const 8 i32.sub call $moonbit.decref)

fn copy(dest : Int, src : Int) -> Unit {
  let src = src - 8
  let dest = dest - 8
  let src_len = load32(src + 4) & 0xFFFFFF
  let dest_len = load32(dest + 4) & 0xFFFFFF
  let min = if src_len < dest_len { src_len } else { dest_len }
  copy_inline(dest, src, min)
}

extern "wasm" fn copy_inline(dest : Int, src : Int, len : Int) =
  #|(func (param i32) (param i32) (param i32) local.get 0 local.get 1 local.get 2 memory.copy)

pub fn realloc(src_offset : Int, dst_size : Int) -> Int {
  let dst = malloc(dst_size)
  copy(dst, src_offset)
  free(src_offset)
  dst
}
