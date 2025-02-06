///|
type Size Int

///|
pub fn Size::op_get(size : Size, index : Int) -> Size = "%i32_mul"

///|
pub fn sizeof(size : Size) -> Int = "%identity"

///|
pub let byte : Size = 1

///|
pub let int_ : Size = 4

///|
pub let uint : Size = 4

///|
pub let int64 : Size = 8

///|
pub let uint64 : Size = 8

///|
pub let float_ : Size = 4

///|
pub let double_ : Size = 8

///|
pub(open) trait Sized {
  size() -> Int
}

///|
pub impl Sized for Byte with size() -> Int { sizeof(byte) }

///|
pub impl Sized for Int with size() -> Int { sizeof(int_) }

///|
pub impl Sized for UInt with size() -> Int { sizeof(uint) }

///|
pub impl Sized for Int64 with size() -> Int { sizeof(int64) }

///|
pub impl Sized for UInt64 with size() -> Int { sizeof(uint64) }

///|
pub impl Sized for Float with size() -> Int { sizeof(float_) }

///|
pub impl Sized for Double with size() -> Int { sizeof(double_) }
