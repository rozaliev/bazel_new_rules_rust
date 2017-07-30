package(default_visibility = ["//visibility:public"])

load("@new_rules_rust//rust:def.bzl", "rust_binary")

rust_binary(
    name = "hello_world",
    srcs = ["src/main.rs"],
    deps = ["//examples/lib2:hello_world_lib"],
)