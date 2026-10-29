///|
/// @bson.derive
struct DerivedAccount {
  /// @bson.rename("display_name")
  name : String
  active : Bool
  last_seen : @bson.DateTime?
} derive(Eq, Debug)

///|
test "derive-like source codegen round trips annotated structs" {
  let account = DerivedAccount::{
    name: "Ada",
    active: true,
    last_seen: Some(@bson.DateTime::from_millis(0L)),
  }
  let encoded = @bson.to_bson(account)
  let document = encoded.as_document().unwrap()
  assert_eq(document.require_string("display_name"), "Ada")
  let decoded : DerivedAccount = @bson.from_bson(encoded)
  assert_eq(decoded, account)
}
