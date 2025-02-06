///|
priv struct Block {
  address : Int
  mut size : Int
  mut occupied : Int?
}

///|
fn Block::output(self : Block, logger : &Logger) -> Unit {
  Show::output(self.address, logger)
  match self.occupied {
    Some(_) => logger.write_string(" + ")
    None => logger.write_string(" - ")
  }
  Show::output(self.address + self.size, logger)
}

///| 64KiB
let page_size = 65536

///|
priv struct Allocator {
  blocks : @builtin.Array[Block]
}

///|
fn Allocator::new() -> Allocator {
  Allocator::{
    blocks: [
      Block::{ address: 0, size: 8, occupied: Some(0) },
      Block::{
        address: 8,
        size: @wasm.memory_size() * page_size - 8,
        occupied: None,
      },
    ],
  }
}

///|
fn Allocator::output(self : Allocator, logger : &Logger) -> Unit {
  logger.write_string("[")
  let last_index = self.blocks.length() - 1
  for i in 0..<last_index {
    let block = self.blocks[i]
    block.output(logger)
    logger.write_string(", ")
  }
  let last_block = self.blocks[last_index]
  Show::output(last_block.address, logger)
  match last_block.occupied {
    Some(_) => logger.write_string(" + ")
    None => logger.write_string(" - ")
  }
  logger.write_string("inf]")
}

///|
fn Allocator::merge_block_backward(self : Allocator, index : Int) -> Int {
  loop index {
    0 => 0
    index => {
      guard let None = self.blocks[index - 1].occupied else {
        Some(_) => return index
      }
      self.blocks[index - 1].size += self.blocks[index].size
      self.blocks.remove(index) |> ignore
      continue index - 1
    }
  }
}

///|
fn Allocator::merge_block_forward(self : Allocator, index : Int) -> Unit {
  while index + 1 < self.blocks.length() {
    guard let None = self.blocks[index + 1].occupied else { Some(_) => return }
    self.blocks[index].size += self.blocks[index + 1].size
    self.blocks.remove(index + 1) |> ignore
  }
}

///|
fn Allocator::grow(self : Allocator, size : Int) -> Int {
  let num_page = (size + page_size - 1) / page_size
  let old_page = @wasm.memory_grow(num_page)
  self.blocks.push(Block::{
    address: old_page * page_size,
    size: num_page * page_size,
    occupied: None,
  })
  self.merge_block_backward(self.blocks.length() - 1)
}

///|
fn Allocator::shrink_block(self : Allocator, index : Int, size : Int) -> Unit {
  if self.blocks[index].size <= size {
    return
  }
  self.blocks.insert(index + 1, Block::{
    address: self.blocks[index].address + size,
    size: self.blocks[index].size - size,
    occupied: None,
  })
  self.blocks[index].size = size
}

///|
fn Allocator::_allocate(self : Allocator, size : Int, length : Int) -> Int {
  for i = 0; i < self.blocks.length(); i = i + 1 {
    guard let None = self.blocks[i].occupied else { Some(_) => continue }
    if self.blocks[i].size < size {
      continue
    }
    self.blocks[i].occupied = Some(length)
    self.shrink_block(i, size)
    return self.blocks[i].address
  }
  let i = self.grow(size)
  if self.blocks[i].size < size {
    abort("out of memory")
  }
  self.blocks[i].occupied = Some(length)
  self.shrink_block(i, size)
  return self.blocks[i].address
}

///|
let empty_block : Int = 0

///|
fn align(address : Int, alignment : Int) -> Int {
  (address + alignment - 1) & (alignment - 1).lnot()
}

///| Allocate a block of memory of the given length.
/// align the length to 8 bytes.
fn Allocator::allocate(self : Allocator, length : Int) -> Int {
  if length == 0 {
    return empty_block
  }
  let size = align(length, 8)
  self._allocate(size, length)
}

test "Allocator::allocate" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(8), content="16")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  inspect!(manager.allocate(16), content="24")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 + 40, 40 - inf]")
  inspect!(manager.allocate(page_size), content="40")
  inspect!(
    manager,
    content="[0 + 8, 8 + 16, 16 + 24, 24 + 40, 40 + 65576, 65576 - inf]",
  )
  inspect!(manager.allocate(8), content="65576")
  inspect!(
    manager,
    content="[0 + 8, 8 + 16, 16 + 24, 24 + 40, 40 + 65576, 65576 + 65584, 65584 - inf]",
  )
}

test "Allocator::allocate - zero length" {
  let manager = Allocator::new()
  inspect!(manager.allocate(0), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  inspect!(manager.allocate(0), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
}

///|
fn Allocator::merge_block(self : Allocator, index : Int) -> Int {
  let index = self.merge_block_backward(index)
  self.merge_block_forward(index)
  index
}

///|
fn Allocator::search_block_length(self : Allocator, address : Int) -> Int {
  if address == empty_block {
    return 0
  }
  let index = self.search_block(address)
  self.blocks[index].occupied.unwrap()
}

///|
fn Allocator::search_block(self : Allocator, address : Int) -> Int {
  let length = self.blocks.length()
  loop 0, length, length / 2 {
    left, right, middle => {
      if left == right {
        abort("invalid free \{address}")
      }
      let block = self.blocks[middle]
      if block.address > address {
        continue left, middle, (left + middle) / 2
      }
      if block.address == address {
        return middle
      }
      if block.address + block.size <= address {
        continue middle + 1, right, (middle + right) / 2
      }
      abort("non-aligned address")
    }
  }
}

///| @alert unsafe "Panic if double free"
fn Allocator::deallocate(self : Allocator, address : Int) -> Unit {
  if address == empty_block {
    return
  }
  let index = self.search_block(address)
  guard let Some(_) = self.blocks[index].occupied else {
    None => abort("double-free \{address}")
  }
  self.blocks[index].occupied = None
  self.merge_block(index) |> ignore
}

test "Allocator::deallocate - reuse" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(8), content="16")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
}

test "Allocator::deallocate - merge" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(8), content="16")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  manager.deallocate(8)
  inspect!(manager, content="[0 + 8, 8 - 16, 16 + 24, 24 - inf]")
  inspect!(manager.allocate(16), content="24")
  inspect!(manager, content="[0 + 8, 8 - 16, 16 + 24, 24 + 40, 40 - inf]")
  inspect!(manager.allocate(16), content="40")
  inspect!(
    manager,
    content="[0 + 8, 8 - 16, 16 + 24, 24 + 40, 40 + 56, 56 - inf]",
  )
  manager.deallocate(16)
  inspect!(manager, content="[0 + 8, 8 - 24, 24 + 40, 40 + 56, 56 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 + 8, 8 - 24, 24 + 40, 40 + 56, 56 - inf]")
}

test "panic Manager::deallocate/double-free" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="0")
  manager.deallocate(0)
  manager.deallocate(0)
}

test "panic Manager::deallocate/invalid-free" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="0")
  manager.deallocate(8)
}

test "Allocator::deallocate/fragment" {
  let manager = Allocator::new()
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(8), content="16")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  inspect!(manager.allocate(16), content="24")
}

test "Allocator::deallocate/zero-length" {
  let manager = Allocator::new()
  inspect!(manager.allocate(0), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  manager.deallocate(empty_block)
  inspect!(manager, content="[0 + 8, 8 - inf]")
}

///| @alert unsafe "Panic if double free"
fn Allocator::reallocate(self : Allocator, address : Int, size : Int) -> Int {
  let index = self.search_block(address)
  let origin = self.blocks[index]
  guard let Some(_) = origin.occupied else {
    None => abort("double-free \{address}")
  }
  let index = self.merge_block(index)
  let merged = self.blocks[index]
  if merged.size > size {
    self.shrink_block(index, size)
    return merged.address
  }
  if merged.size == size {
    return merged.address
  }
  merged.occupied = None
  let destination = Allocator::allocate(self, size)
  @wasm.memory_copy(destination, address, origin.size)
  destination
}

test "Allocator::reallocate" {
  let manager = Allocator::new()
  inspect!(manager, content="[0 + 8, 8 - inf]")
  let address_42 = manager.allocate(4)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(address_42, content="8")
  @wasm.i32_store(address_42, 42)
  let address_37 = manager.allocate(4)
  @wasm.i32_store(address_37, 37)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  let address_84 = manager.reallocate(address_42, 8)
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 24, 24 - inf]")
  inspect!(address_84, content="8")
  inspect!(@wasm.i32_load(address_84), content="42")
  inspect!(@wasm.i32_load(address_84 + 4), content="0")
}
