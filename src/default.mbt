///|
trait Default {
  default() -> Self
}

///|
pub impl Default for Byte with default() -> Byte { 0 }

///|
pub impl Default for Int16 with default() -> Int16 { 0 }

///|
pub impl Default for UInt16 with default() -> UInt16 { 0 }

///|
pub impl Default for Int with default() -> Int { 0 }

///|
pub impl Default for UInt with default() -> UInt { 0 }

///|
pub impl Default for Int64 with default() -> Int64 { 0 }

///|
pub impl Default for UInt64 with default() -> UInt64 { 0 }

///|
pub impl Default for Float with default() -> Float { 0.0 }

///|
pub impl Default for Double with default() -> Double { 0.0 }
