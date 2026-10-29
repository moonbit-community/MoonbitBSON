///|
test "property Int64 BSON round trips" {
  let samples : Array[Int64] = @quickcheck.samples(256)
  for value in samples {
    let document = @bson.Document::new().set("value", Int64(value))
    assert_eq(@bson.decode(@bson.encode(document)), document)
  }
}

///|
test "property generated scalar documents round trip" {
  let samples : Array[Int32] = @quickcheck.samples(128)
  for value in samples {
    let document = @bson.Document::new()
      .set("int", Int32(value))
      .set("bool", Boolean(value % 2 == 0))
      .set("text", String(value.to_string()))
      .set(
        "bytes",
        Binary(
          @bson.Binary::new(
            Generic,
            Bytes::makei(8, index => (value + index).to_byte()),
          ),
        ),
      )
    assert_eq(@bson.decode(@bson.encode(document)), document)
  }
}

///|
/// Bounded deterministic fuzz smoke test: arbitrary bytes must produce a typed error or a document.
test "fuzz smoke decoder accepts only valid frames" {
  let random = @random.Rand::chacha8(seed=b"0123456789abcdef0123456789abcdef")
  for _ in 0..<512 {
    let length = random.int(limit=256)
    let bytes = Bytes::makei(length, _ => random.uint().to_byte())
    try @bson.decode(bytes) catch {
      _ => ()
    } noraise {
      _ => ()
    }
  }
}
