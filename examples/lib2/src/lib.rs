extern crate hello_lib;

use hello_lib::hello;

pub fn hello_world() {
    hello();
    println!("world");
}