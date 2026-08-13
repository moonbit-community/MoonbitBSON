///|
/// Decode one complete BSON document.
pub fn decode_bson(data : Bytes) -> BsonValue raise BsonError {
  let reader = BsonReader::new(data)
  let document = decode_document(reader)
  if !reader.is_empty() {
    raise InvalidDocumentLength("Trailing bytes after BSON document")
  }
  document
}

///|
fn read_container_body(
  reader : BsonReader,
  kind : String,
) -> BsonReader raise BsonError {
  let total_length = reader.read_i32()
  if total_length < 5 {
    raise InvalidDocumentLength("BSON " + kind + " is shorter than 5 bytes")
  }
  BsonReader::new(reader.read_exact(total_length - 4))
}

///|
fn validate_container_end(
  reader : BsonReader,
  kind : String,
) -> Unit raise BsonError {
  if reader.remaining() != 1 || reader.read_byte() != 0x00 {
    raise InvalidDocumentLength(
      "BSON " + kind + " length does not end at its terminator",
    )
  }
}

///|
fn decode_document(reader : BsonReader) -> BsonValue raise BsonError {
  let body = read_container_body(reader, "document")
  let map = Map([], capacity=8)
  while body.remaining() > 1 {
    let type_code = body.read_byte()
    if type_code == 0x00 {
      raise InvalidDocumentLength(
        "BSON document terminates before its declared length",
      )
    }
    let key = decode_cstring(body)
    map.set(key, decode_element(type_code, body))
  }
  validate_container_end(body, "document")
  Document(map)
}

///|
fn decode_element(
  type_code : Byte,
  reader : BsonReader,
) -> BsonValue raise BsonError {
  match type_code {
    0x01 => Double(reader.read_double())
    0x02 => String(decode_string(reader))
    0x03 => decode_document(reader)
    0x04 => decode_array(reader)
    0x08 => Boolean(reader.read_byte() != 0)
    0x0A => Null
    0x10 => Int32(reader.read_i32())
    0x12 => Int64(reader.read_i64())
    _ => raise UnsupportedType(type_code)
  }
}

///|
fn decode_array(reader : BsonReader) -> BsonValue raise BsonError {
  let body = read_container_body(reader, "array")
  let values : Array[BsonValue] = []
  while body.remaining() > 1 {
    let type_code = body.read_byte()
    if type_code == 0x00 {
      raise InvalidDocumentLength(
        "BSON array terminates before its declared length",
      )
    }
    ignore(decode_cstring(body))
    values.push(decode_element(type_code, body))
  }
  validate_container_end(body, "array")
  Array(values)
}

///|
fn decode_utf8(bytes : BytesView, context : String) -> String raise BsonError {
  try @utf8.decode(bytes) catch {
    _ => raise InvalidUtf8("Invalid UTF-8 in BSON " + context)
  } noraise {
    value => value
  }
}

///|
fn decode_cstring(reader : BsonReader) -> String raise BsonError {
  decode_utf8(reader.read_cstring_bytes(), "CString")
}

///|
fn decode_string(reader : BsonReader) -> String raise BsonError {
  let length = reader.read_i32()
  if length <= 0 {
    raise InvalidStringLength("BSON string length must be positive")
  }
  let raw = reader.read_exact(length)
  if raw[length - 1] != 0x00 {
    raise InvalidString("BSON string is missing its null terminator")
  }
  decode_utf8(raw[0:length - 1], "string")
}
