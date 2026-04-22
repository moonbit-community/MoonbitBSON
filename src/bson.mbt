///| Top-level convenience API: encode to Bytes
/// Raises BsonError if encoding fails
pub fn to_bson(value : BsonValue) -> Bytes raise Error {
  encode_bson(value)
}

///| Top-level convenience API: decode from Bytes
/// Raises BsonError if decoding fails
pub fn from_bson(bytes : Bytes) -> BsonValue raise Error {
  decode_bson(bytes)
}

///| Safe wrapper: encode to Bytes
/// Returns empty Bytes on failure
pub fn to_bson_safe(value : BsonValue) -> Bytes {
  try encode_bson(value) catch {
    _ => Bytes::from_array([])
  } noraise {
    b => b
  }
}

///| Safe wrapper: decode from Bytes
/// Returns Null on failure
pub fn from_bson_safe(bytes : Bytes) -> BsonValue {
  try decode_bson(bytes) catch {
    _ => BsonValue::Null
  } noraise {
    v => v
  }
}
