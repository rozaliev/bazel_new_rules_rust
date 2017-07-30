extern crate hello_lib;
#[macro_use]
extern crate hello_macro;

use hello_lib::hello;

#[derive(Hello)]
struct Dummy;

pub fn hello_world() {
    let _ = Dummy;
    let _ = Dummy2;
    hello();
    println!("world");
}