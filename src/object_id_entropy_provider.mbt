///|
/// Host-provided secure entropy hook for portable targets such as Wasm.
/// The callback must return exactly `count` unpredictable bytes, or `None`
/// when it cannot satisfy the request.
pub type SecureEntropyProvider = (Int32) -> Bytes?

///|
let secure_entropy_provider : Ref[SecureEntropyProvider?] = Ref(None)

///|
pub fn install_secure_entropy_provider(
  provider : SecureEntropyProvider,
) -> Unit {
  secure_entropy_provider.val = Some(provider)
}

///|
pub fn clear_secure_entropy_provider() -> Unit {
  secure_entropy_provider.val = None
}

///|
pub fn secure_entropy_from_provider(count : Int32) -> Bytes? raise BsonError {
  match secure_entropy_provider.val {
    None => None
    Some(provider) =>
      match provider(count) {
        None => None
        Some(bytes) => {
          if bytes.length() != count {
            raise bson_error(
              UnsupportedEntropy,
              -1,
              "$.\u{24}oid",
              "secure entropy provider returned an incorrect byte count",
            )
          }
          Some(bytes)
        }
      }
  }
}
