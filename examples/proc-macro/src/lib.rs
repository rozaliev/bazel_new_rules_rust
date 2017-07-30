extern crate proc_macro;

use std::str::FromStr;

use proc_macro::TokenStream;

#[proc_macro_derive(Hello)]
pub fn hello_world(_: TokenStream) -> TokenStream {
    TokenStream::from_str("struct Dummy2;").unwrap()
}