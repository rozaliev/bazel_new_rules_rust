load("@new_rules_rust//rust/private:binary.bzl", "rust_binary")
load("@new_rules_rust//rust/private:library.bzl", "rust_library")

def rust_binary_macro(name, **kwargs):
    return rust_binary(name = name, **kwargs)

def rust_library_macro(name, **kwargs):
    return rust_library(name = name, **kwargs)
