package(default_visibility = ["//visibility:public"])

load("@new_rules_rust//rust:def.bzl", "rust_library")

rust_library(
    name = "hello_world_lib",
    srcs = ["src/lib.rs"],
    deps = ["//examples/lib:hello_lib"]
)