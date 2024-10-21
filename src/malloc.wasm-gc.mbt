priv struct Block {
  address : Int
  mut size : Int
  mut occupied : Bool
}

fn Block::output(self : Block, logger : Logger) -> Unit {
  Show::output(self.address, logger)
  if self.occupied {
    logger.write_string(" + ")
  } else {
    logger.write_string(" - ")
  }
  Show::output(self.address + self.size, logger)
}

let page_size = 65536

extern "wasm" fn memory_size() -> Int =
  #|(func (result i32)
  #| memory.size)

extern "wasm" fn memory_grow(size : Int) -> Int =
  #|(func (param i32) (result i32)
  #| local.get 0
  #| memory.grow)

priv struct Manager {
  blocks : Array[Block]
}

fn Manager::new() -> Manager {
  Manager::{
    blocks: [
      Block::{ address: 0, size: memory_size() * page_size, occupied: false },
    ],
  }
}

fn Manager::output(self : Manager, logger : Logger) -> Unit {
  logger.write_string("[")
  let last_index = self.blocks.length() - 1
  for i in 0..<last_index {
    let block = self.blocks[i]
    block.output(logger)
    logger.write_string(", ")
  }
  let last_block = self.blocks[last_index]
  Show::output(last_block.address, logger)
  if last_block.occupied {
    logger.write_string(" + ")
  } else {
    logger.write_string(" - ")
  }
  logger.write_string("inf]")
}

fn Manager::merge_block_backward(self : Manager, index : Int) -> Int {
  loop index {
    0 => 0
    index => {
      if self.blocks[index - 1].occupied {
        return index
      }
      self.blocks[index - 1].size += self.blocks[index].size
      self.blocks.remove(index) |> ignore
      continue index - 1
    }
  }
}

fn Manager::merge_block_forward(self : Manager, index : Int) -> Unit {
  while index + 1 < self.blocks.length() {
    if self.blocks[index + 1].occupied {
      return
    }
    self.blocks[index].size += self.blocks[index + 1].size
    self.blocks.remove(index + 1) |> ignore
  }
}

fn Manager::grow(self : Manager, size : Int) -> Int {
  let num_page = (size + page_size - 1) / page_size
  let old_page = memory_grow(num_page)
  self.blocks.push(
    Block::{
      address: old_page * page_size,
      size: num_page * page_size,
      occupied: false,
    },
  )
  self.merge_block_backward(self.blocks.length() - 1)
}

fn Manager::shrink_block(self : Manager, index : Int, size : Int) -> Unit {
  if self.blocks[index].size <= size {
    return
  }
  self.blocks.insert(
    index + 1,
    Block::{
      address: self.blocks[index].address + size,
      size: self.blocks[index].size - size,
      occupied: false,
    },
  )
  self.blocks[index].size = size
}

let empty_block = 65536

fn Manager::allocate(self : Manager, size : Int) -> Int {
  if size == 0 {
    return empty_block
  }
  for i = 0; i < self.blocks.length(); i = i + 1 {
    if self.blocks[i].occupied {
      continue
    }
    if self.blocks[i].size < size {
      continue
    }
    self.blocks[i].occupied = true
    self.shrink_block(i, size)
    return self.blocks[i].address
  }
  let i = self.grow(size)
  if self.blocks[i].size < size {
    abort("out of memory")
  }
  self.blocks[i].occupied = true
  self.shrink_block(i, size)
  return self.blocks[i].address
}

test "Manager::allocate" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(16), content="16")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 32, 32 - inf]")
  inspect!(manager.allocate(page_size), content="32")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 + 32, 32 + 65568, 65568 - inf]")
  inspect!(manager.allocate(8), content="65568")
  inspect!(
    manager,
    content="[0 + 8, 8 + 16, 16 + 32, 32 + 65568, 65568 + 65576, 65576 - inf]",
  )
}

test "Manager::allocate - zero length" {
  let manager = Manager::new()
  inspect!(manager.allocate(0), content="65536")
  inspect!(manager, content="[0 - inf]")
  inspect!(manager.allocate(0), content="65536")
  inspect!(manager, content="[0 - inf]")
}

fn Manager::merge_block(self : Manager, index : Int) -> Int {
  let index = self.merge_block_backward(index)
  self.merge_block_forward(index)
  index
}

fn Manager::search_block(self : Manager, address : Int) -> Int {
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
        continue middle, right, (middle + right) / 2
      }
      abort("non-aligned address")
    }
  }
}

fn Manager::deallocate(self : Manager, address : Int) -> Unit {
  if address == empty_block {
    return
  }
  let index = self.search_block(address)
  if not(self.blocks[index].occupied) {
    abort("double-free \{address}")
  }
  self.blocks[index].occupied = false
  self.merge_block(index) |> ignore
}

test "Manager::deallocate - reuse" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 - inf]")
  inspect!(manager.allocate(8), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
}

test "Manager::deallocate - merge" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 - 8, 8 + 16, 16 - inf]")
  manager.deallocate(8)
  inspect!(manager, content="[0 - inf]")
  inspect!(manager.allocate(16), content="0")
  inspect!(manager, content="[0 + 16, 16 - inf]")
  inspect!(manager.allocate(16), content="16")
  inspect!(manager, content="[0 + 16, 16 + 32, 32 - inf]")
  manager.deallocate(16)
  inspect!(manager, content="[0 + 16, 16 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 - inf]")
}

test "panic Manager::deallocate - double free" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  manager.deallocate(0)
  manager.deallocate(0)
}

test "panic Manager::deallocate - invalid free" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  manager.deallocate(8)
}

test "Manager::deallocate - fragment" {
  let manager = Manager::new()
  inspect!(manager.allocate(8), content="0")
  inspect!(manager, content="[0 + 8, 8 - inf]")
  inspect!(manager.allocate(8), content="8")
  inspect!(manager, content="[0 + 8, 8 + 16, 16 - inf]")
  manager.deallocate(0)
  inspect!(manager, content="[0 - 8, 8 + 16, 16 - inf]")
  inspect!(manager.allocate(16), content="16")
}

test "Manager::deallocate - zero length" {
  let manager = Manager::new()
  inspect!(manager.allocate(0), content="65536")
  inspect!(manager, content="[0 - inf]")
  manager.deallocate(65536)
  inspect!(manager, content="[0 - inf]")
}

fn Manager::reallocate(self : Manager, address : Int, size : Int) -> Int {
  let index = self.search_block(address)
  let origin = self.blocks[index]
  if not(origin.occupied) {
    abort("double-free \{address}")
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
  merged.occupied = false
  let destination = Manager::allocate(self, size)
  memory_copy(destination, address, origin.size)
  destination
}

extern "wasm" fn store_i32(address : Int, value : Int) =
  #|(func (param i32) (param i32)
  #| local.get 0
  #| local.get 1
  #| i32.store)

extern "wasm" fn load_i32(address : Int) -> Int =
  #|(func (param i32) (result i32)
  #| local.get 0
  #| i32.load)

test "Manager::reallocate" {
  let manager = Manager::new()
  let address_42 = manager.allocate(4)
  store_i32(address_42, 42)
  let address_37 = manager.allocate(4)
  store_i32(address_37, 37)
  let address_84 = manager.reallocate(address_42, 8)
  inspect!(manager, content="[0 - 4, 4 + 8, 8 + 16, 16 - inf]")
  inspect!(address_84, content="8")
  inspect!(load_i32(address_84), content="42")
  inspect!(load_i32(address_84 + 4), content="0")
}

let manager : Manager = Manager::new()

/// Allocates a block of memory of the specified `size` and returns the address
/// of the allocated memory.
///
/// Parameters:
///
/// - `size`: The size of the memory block to allocate, in bytes.
///
/// Returns the address of the allocated memory block as an integer.
pub fn malloc(size : Int) -> Int {
  manager.allocate(size)
}

/// Deallocates a block of memory at the specified address.
///
/// Parameters:
///
/// - `address` : The address of the memory block to be deallocated.
pub fn free(address : Int) -> Unit {
  manager.deallocate(address)
}

/// Reallocate memory at the given `address` to the specified `size`.
///
/// Parameters:
///
/// - `address`: The memory address to reallocate.
/// - `size`: The new size for the memory block.
///
/// Returns the new memory address after reallocation.
pub fn realloc(address : Int, size : Int) -> Int {
  manager.reallocate(address, size)
}
