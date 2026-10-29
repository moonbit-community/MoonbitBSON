///|
pub struct EncodeOptions {
  max_depth : Int32
  max_size : Int32
} derive(Eq, Debug)

///|
pub fn EncodeOptions::new(
  max_depth~ : Int32 = 100,
  max_size~ : Int32 = 16 * 1024 * 1024,
) -> EncodeOptions {
  { max_depth, max_size, }
}

///|
pub fn EncodeOptions::max_depth(self : EncodeOptions) -> Int32 {
  self.max_depth
}

///|
pub fn EncodeOptions::max_size(self : EncodeOptions) -> Int32 {
  self.max_size
}

///|
pub struct DecodeOptions {
  max_depth : Int32
  max_size : Int32
  require_canonical_array_keys : Bool
} derive(Eq, Debug)

///|
pub fn DecodeOptions::new(
  max_depth~ : Int32 = 100,
  max_size~ : Int32 = 16 * 1024 * 1024,
  require_canonical_array_keys~ : Bool = false,
) -> DecodeOptions {
  { max_depth, max_size, require_canonical_array_keys, }
}

///|
pub fn DecodeOptions::max_depth(self : DecodeOptions) -> Int32 {
  self.max_depth
}

///|
pub fn DecodeOptions::max_size(self : DecodeOptions) -> Int32 {
  self.max_size
}

///|
pub fn DecodeOptions::require_canonical_array_keys(
  self : DecodeOptions,
) -> Bool {
  self.require_canonical_array_keys
}
