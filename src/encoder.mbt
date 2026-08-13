///|
/// Encode a complete BSON document.
pub fn encode_bson(doc : BsonValue) -> Bytes raise BsonError {
  match doc {
    Document(map) => encode_document(map)
    _ => raise InvalidDocumentLength("Top-level value must be a Document")
  }
}

///|
fn encode_document(map : Map[String, BsonValue]) -> Bytes raise BsonError {
  let writer = Buffer(size_hint=128)
  write_document(writer, map)
  writer.to_bytes()
}

///|
fn write_document(
  writer : Buffer,
  map : Map[String, BsonValue],
) -> Unit raise BsonError {
  let body = Buffer(size_hint=128)
  for key, value in map {
    body.write_byte(get_type_code(value))
    write_cstring(body, key)
    write_element(body, value)
  }
  write_container(writer, body)
}

///|
fn write_container(writer : Buffer, body : Buffer) -> Unit {
  body.write_byte(0x00)
  writer.write_int_le(body.length() + 4)
  writer.write_bytes(body.to_bytes())
}

///|
fn get_type_code(value : BsonValue) -> Byte {
  match value {
    Double(_) => 0x01
    String(_) => 0x02
    Document(_) => 0x03
    Array(_) => 0x04
    Boolean(_) => 0x08
    Null => 0x0A
    Int32(_) => 0x10
    Int64(_) => 0x12
  }
}

///|
fn write_element(writer : Buffer, value : BsonValue) -> Unit raise BsonError {
  match value {
    Double(value) => writer.write_double_le(value)
    String(value) => write_string(writer, value)
    Document(value) => write_document(writer, value)
    Array(value) => write_array(writer, value)
    Boolean(value) => writer.write_byte(if value { 1 } else { 0 })
    Null => ()
    Int32(value) => writer.write_int_le(value)
    Int64(value) => writer.write_int64_le(value)
  }
}

///|
fn write_array(
  writer : Buffer,
  values : Array[BsonValue],
) -> Unit raise BsonError {
  let body = Buffer(size_hint=128)
  for index, value in values {
    body.write_byte(get_type_code(value))
    write_cstring(body, index.to_string())
    write_element(body, value)
  }
  write_container(writer, body)
}

///|
fn write_cstring(writer : Buffer, value : String) -> Unit raise BsonError {
  let bytes = @utf8.encode(value)
  if bytes.find(b"\x00") is Some(_) {
    raise InvalidString("CString cannot contain a null character")
  }
  writer.write_bytes(bytes)
  writer.write_byte(0x00)
}

///|
fn write_string(writer : Buffer, value : String) -> Unit {
  let bytes = @utf8.encode(value)
  writer.write_int_le(bytes.length() + 1)
  writer.write_bytes(bytes)
  writer.write_byte(0x00)
}
