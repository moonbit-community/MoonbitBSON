///|
/// A bounded cursor over BSON input.
priv struct BsonReader {
  data : BytesView
  mut pos : Int
}

///|
fn BsonReader::new(data : BytesView) -> BsonReader {
  { data, pos: 0 }
}

///|
fn BsonReader::remaining(self : BsonReader) -> Int {
  self.data.length() - self.pos
}

///|
fn BsonReader::is_empty(self : BsonReader) -> Bool {
  self.pos == self.data.length()
}

///|
fn BsonReader::read_exact(
  self : BsonReader,
  length : Int,
) -> BytesView raise BsonError {
  if length < 0 || length > self.remaining() {
    raise InvalidDocumentLength("Unexpected end of BSON input")
  }
  let start = self.pos
  self.pos += length
  self.data[start:self.pos]
}

///|
fn BsonReader::read_byte(self : BsonReader) -> Byte raise BsonError {
  if self.is_empty() {
    raise InvalidDocumentLength("Unexpected end of BSON input")
  }
  let byte = self.data[self.pos]
  self.pos += 1
  byte
}

///|
fn BsonReader::read_i32(self : BsonReader) -> Int raise BsonError {
  guard! self.read_exact(4) is [i32le(value), ..]
  value
}

///|
fn BsonReader::read_i64(self : BsonReader) -> Int64 raise BsonError {
  guard! self.read_exact(8) is [i64le(value), ..]
  value
}

///|
fn BsonReader::read_double(self : BsonReader) -> Double raise BsonError {
  guard! self.read_exact(8) is [u64le(bits), ..]
  bits.reinterpret_as_double()
}

///|
fn BsonReader::read_cstring_bytes(
  self : BsonReader,
) -> BytesView raise BsonError {
  let start = self.pos
  while !self.is_empty() {
    if self.read_byte() == 0x00 {
      return self.data[start:self.pos - 1]
    }
  }
  raise InvalidString("CString is missing its null terminator")
}
