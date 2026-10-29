///|
fn benchmark_document() -> @bson.Document {
  let document = @bson.Document::new()
  for index in 0..<128 {
    document.set(
      "field_" + index.to_string(),
      String("value-" + index.to_string()),
    )
    |> ignore
  }
  document
  .set("nested", Document(@bson.Document::new().set("enabled", Boolean(true))))
  .set("payload", Binary(@bson.Binary::new(Generic, Bytes::make(512, 0x41))))
}

///|
fn benchmark_encode(document : @bson.Document) -> Bytes {
  try @bson.encode(document) catch {
    _ => abort("benchmark fixture failed to encode")
  } noraise {
    bytes => bytes
  }
}

///|
fn benchmark_decode(bytes : Bytes) -> @bson.Document {
  try @bson.decode(bytes) catch {
    _ => abort("benchmark fixture failed to decode")
  } noraise {
    document => document
  }
}

///|
fn benchmark_raw_lookup(raw : @bson.RawDocument) -> @bson.Bson {
  try raw.get_element("field_96").unwrap().to_bson() catch {
    _ => abort("benchmark fixture failed during raw lookup")
  } noraise {
    value => value
  }
}

///|
test "bench BSON encode 128-field document" (it : @bench.T) {
  let document = benchmark_document()
  it.bench(fn() { it.keep(benchmark_encode(document)) })
}

///|
test "bench BSON decode 128-field document" (it : @bench.T) {
  let bytes = benchmark_encode(benchmark_document())
  it.bench(fn() { it.keep(benchmark_decode(bytes)) })
}

///|
test "bench RawDocument lazy element lookup" (it : @bench.T) {
  let raw = @bson.RawDocument::from_bytes(
    benchmark_encode(benchmark_document()),
  )
  it.bench(fn() { it.keep(benchmark_raw_lookup(raw)) })
}

///|
fn benchmark_raw_view_lookup(view : @bson.RawDocumentView) -> BytesView {
  try {
    let iterator = view.iter()
    while iterator.next() is Some(element) {
      if element.key() == "field_96" {
        return element.raw_bytes()
      }
    }
    abort("benchmark field missing")
  } catch {
    _ => abort("benchmark raw view lookup failed")
  } noraise {
    value => value
  }
}

///|
test "bench borrowed RawDocumentView lookup" (it : @bench.T) {
  let view = @bson.RawDocumentView::from_bytes(
    benchmark_encode(benchmark_document())[:],
  )
  it.bench(fn() { it.keep(benchmark_raw_view_lookup(view)) })
}
