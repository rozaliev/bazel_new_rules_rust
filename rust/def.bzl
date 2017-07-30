load("@new_rules_rust//rust/private:wrappers.bzl", "rust_binary_macro", "rust_library_macro")
load("@new_rules_rust//rust/private:repositories.bzl", "rust_repositories")

rust_binary = rust_binary_macro
rust_library = rust_library_macro