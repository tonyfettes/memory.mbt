///|
pub(open) trait Sized {
  size() -> Int
}

///|
pub impl Sized for Byte with size() -> Int { 1 }

///|
pub impl Sized for Int with size() -> Int { 4 }

///|
pub impl Sized for UInt with size() -> Int { 4 }

///|
pub impl Sized for Int64 with size() -> Int { 8 }

///|
pub impl Sized for UInt64 with size() -> Int { 8 }

///|
pub impl Sized for Float with size() -> Int { 4 }

///|
pub impl Sized for Double with size() -> Int { 8 }
