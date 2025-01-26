///|
type Size Int derive(Eq, Hash)

///|
pub fn Size::op_get(self : Size, length : Int) -> Size = "%i32_mul"

///|
pub let byte : Size = 1

///|
pub let int : Size = 4

///|
pub let uint : Size = 4

///|
pub let int64 : Size = 8

///|
pub let uint64 : Size = 8

///|
pub let float : Size = 4

///|
pub let double : Size = 8

///|
pub fn sizeof(type_ : Size) -> Int = "%identity"

///|
pub(open) trait Sized {
  size() -> Int
}

///|
pub impl Sized for Byte with size() -> Int { sizeof(byte) }

///|
pub impl Sized for Int with size() -> Int { sizeof(int) }

///|
pub impl Sized for UInt with size() -> Int { sizeof(uint) }

///|
pub impl Sized for Int64 with size() -> Int { sizeof(int64) }

///|
pub impl Sized for UInt64 with size() -> Int { sizeof(uint64) }

///|
pub impl Sized for Float with size() -> Int { sizeof(float) }

///|
pub impl Sized for Double with size() -> Int { sizeof(double) }
