///|
test "Invalid Document Length" {
  // Declared length is 1, which is too short to be valid BSON
  let invalid_bytes = Bytes::from_array([0x01, 0x00, 0x00, 0x00])
  @test.assert_raise(() => decode_bson(invalid_bytes))
}

///|
test "CString Missing Null Terminator" {
  // Missing 0x00 terminator after key
  let data : Array[Byte] = [0x05, 0x00, 0x00, 0x00, 0x02, 0x78, 0x79]
  @test.assert_raise(() => decode_bson(Bytes::from_array(data)))
}

///|
test "Unsupported Type Decode" {
  // 0xFF is not a valid BSON type code
  let data : Array[Byte] = [
    0x08, 0x00, 0x00, 0x00, 0xFF, 0x61, 0x00, // key = "a"
     0x00,
  ] // document end
  @test.assert_raise(() => decode_bson(Bytes::from_array(data)))
}

///|
test "Int64 uses BSON little-endian encoding" {
  let doc = bson_document().set("i", bson_int64(0x0102030405060708L))
  let expected : Bytes = [
    0x10, 0x00, 0x00, 0x00, 0x12, 0x69, 0x00, 0x08, 0x07, 0x06, 0x05, 0x04, 0x03,
    0x02, 0x01, 0x00,
  ]
  assert_eq(encode_bson(doc), expected)
  assert_eq(encode_bson(decode_bson(expected)), expected)
}

///|
test "Double uses BSON little-endian encoding" {
  let doc = bson_document().set("d", bson_double(3.14))
  let expected : Bytes = [
    0x10, 0x00, 0x00, 0x00, 0x01, 0x64, 0x00, 0x1F, 0x85, 0xEB, 0x51, 0xB8, 0x1E,
    0x09, 0x40, 0x00,
  ]
  assert_eq(encode_bson(doc), expected)
  assert_eq(encode_bson(decode_bson(expected)), expected)
}

///|
test "Malformed UTF-8 is rejected" {
  let malformed : Bytes = [
    0x0E, 0x00, 0x00, 0x00, 0x02, 0x78, 0x00, 0x02, 0x00, 0x00, 0x00, 0x80, 0x00,
    0x00,
  ]
  try decode_bson(malformed) catch {
    InvalidUtf8(_) => ()
    _ => fail("expected InvalidUtf8")
  } noraise {
    _ => fail("expected malformed UTF-8 to be rejected")
  }
}

///|
test "Trailing bytes are rejected" {
  let data : Bytes = [0x05, 0x00, 0x00, 0x00, 0x00, 0x00]
  @test.assert_raise(() => decode_bson(data))
}

///|
test "CString keys cannot contain null" {
  let doc = bson_document().set("bad\u{0000}key", bson_int32(1))
  try encode_bson(doc) catch {
    InvalidString(_) => ()
    _ => fail("expected InvalidString")
  } noraise {
    _ => fail("expected CString key to be rejected")
  }
}

///|
test "Truncated document body is rejected" {
  let data : Bytes = [0x05, 0x00, 0x00, 0x00]
  @test.assert_raise(() => decode_bson(data))
}

///|
test "Truncated element value is rejected" {
  let data : Bytes = [0x07, 0x00, 0x00, 0x00, 0x08, 0x61, 0x00]
  @test.assert_raise(() => decode_bson(data))
}

///|
test "Early document terminator is rejected" {
  let data : Bytes = [0x06, 0x00, 0x00, 0x00, 0x00, 0x00]
  @test.assert_raise(() => decode_bson(data))
}

///|
test "Early array terminator is rejected" {
  let data : Bytes = [
    0x0E, 0x00, 0x00, 0x00, 0x04, 0x61, 0x00, 0x06, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00,
  ]
  @test.assert_raise(() => decode_bson(data))
}

///|
test "Invalid BSON string lengths and terminators are rejected" {
  let zero_length : Bytes = [
    0x0C, 0x00, 0x00, 0x00, 0x02, 0x78, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  ]
  let missing_terminator : Bytes = [
    0x0E, 0x00, 0x00, 0x00, 0x02, 0x78, 0x00, 0x02, 0x00, 0x00, 0x00, 0x61, 0x01,
    0x00,
  ]
  @test.assert_raise(() => decode_bson(zero_length))
  @test.assert_raise(() => decode_bson(missing_terminator))
}

///|
test "Top-level encoding requires a document" {
  @test.assert_raise(() => encode_bson(bson_null()))
}

///|
test "Convenience and safe APIs preserve their contracts" {
  let doc = bson_document().set("answer", bson_int32(42))
  let bytes = to_bson(doc)
  assert_eq(to_bson(from_bson(bytes)), bytes)
  assert_eq(to_bson_safe(doc), bytes)
  assert_eq(to_bson(from_bson_safe(bytes)), bytes)
  assert_eq(to_bson_safe(bson_null()), b"")
  match from_bson_safe(b"\x01\x00\x00\x00") {
    Null => ()
    _ => fail("safe decoding should return Null on failure")
  }
}
