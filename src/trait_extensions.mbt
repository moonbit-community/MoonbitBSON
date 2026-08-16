///|
/// Keeps trait methods available through dot syntax.
pub extend DateTime with Eq::{not_equal, equal}

///|
pub extend DateTime with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BsonErrorKind with Eq::{not_equal, equal}

///|
pub extend BsonErrorKind with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BsonErrorInfo with Eq::{not_equal, equal}

///|
pub extend BsonErrorInfo with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BsonError with Eq::{not_equal, equal}

///|
pub extend BsonError with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend EncodeOptions with Eq::{not_equal, equal}

///|
pub extend EncodeOptions with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DecodeOptions with Eq::{not_equal, equal}

///|
pub extend DecodeOptions with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawElement with Eq::{not_equal, equal}

///|
pub extend RawElement with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawStringRef with Eq::{not_equal, equal}

///|
pub extend RawStringRef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawBinaryRef with Eq::{not_equal, equal}

///|
pub extend RawBinaryRef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawRegexRef with Eq::{not_equal, equal}

///|
pub extend RawRegexRef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawDbPointerRef with Eq::{not_equal, equal}

///|
pub extend RawDbPointerRef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawJavaScriptWithScopeRef with Eq::{not_equal, equal}

///|
pub extend RawJavaScriptWithScopeRef with @moonbitlang/core/debug.Debug::{
  to_repr,
}

///|
pub extend RawBsonRef with Eq::{not_equal, equal}

///|
pub extend RawBsonRef with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawArrayView with Eq::{not_equal, equal}

///|
pub extend RawArrayView with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawDocumentView with Eq::{not_equal, equal}

///|
pub extend RawDocumentView with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawElementView with Eq::{not_equal, equal}

///|
pub extend RawElementView with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Bson with ToBson::{to_bson}

///|
pub extend Bson with FromBson::{from_bson}

///|
pub extend Document with ToBson::{to_bson}

///|
pub extend Document with FromBson::{from_bson}

///|
pub extend DateTime with ToBson::{to_bson}

///|
pub extend DateTime with FromBson::{from_bson}

///|
pub extend ObjectId with ToBson::{to_bson}

///|
pub extend ObjectId with FromBson::{from_bson}

///|
pub extend Decimal128 with ToBson::{to_bson}

///|
pub extend Decimal128 with FromBson::{from_bson}

///|
pub extend Uuid with ToBson::{to_bson}

///|
pub extend Uuid with FromBson::{from_bson}

///|
pub extend BsonStreamDecoder with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BsonStreamRawDecoder with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Uuid with Eq::{not_equal, equal}

///|
pub extend Uuid with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend BinarySubtype with Eq::{not_equal, equal}

///|
pub extend BinarySubtype with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Binary with Eq::{not_equal, equal}

///|
pub extend Binary with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend ObjectId with Eq::{not_equal, equal}

///|
pub extend ObjectId with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Regex with Eq::{not_equal, equal}

///|
pub extend Regex with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Timestamp with Eq::{not_equal, equal}

///|
pub extend Timestamp with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Decimal128 with Eq::{not_equal, equal}

///|
pub extend Decimal128 with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DbPointer with Eq::{not_equal, equal}

///|
pub extend DbPointer with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend JavaScriptWithScope with Eq::{not_equal, equal}

///|
pub extend JavaScriptWithScope with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Document with Eq::{not_equal, equal}

///|
pub extend Document with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend Bson with Eq::{not_equal, equal}

///|
pub extend Bson with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RawDocument with Eq::{not_equal, equal}

///|
pub extend RawDocument with @moonbitlang/core/debug.Debug::{to_repr}
