///|
/// Keeps trait methods available through dot syntax.
pub extend CodegenUser with @moonbit-community/bson.ToBson::{to_bson}

///|
pub extend CodegenUser with @moonbit-community/bson.FromBson::{from_bson}

///|
pub extend CodegenUser with Eq::{not_equal, equal}

///|
pub extend CodegenUser with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend DerivedAccount with @moonbit-community/bson.ToBson::{to_bson}

///|
pub extend DerivedAccount with @moonbit-community/bson.FromBson::{from_bson}

///|
pub extend DerivedAccount with Eq::{not_equal, equal}

///|
pub extend DerivedAccount with @moonbitlang/core/debug.Debug::{to_repr}
