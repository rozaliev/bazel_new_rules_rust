load("@new_rules_rust//rust/private:common.bzl", "rust_filetype")
load("@new_rules_rust//rust/private:rust_toolchain.bzl", "TOOLCHAIN_TYPE")
load("@new_rules_rust//rust/private:providers.bzl", "RustLibrary", "RustBinary")
load("@new_rules_rust//rust/private:compile.bzl", "emit_rust_compile_actions", "find_crate_root")

def _rust_binary_impl(ctx):
    
    transitive_rust_library_deps = depset()
    for d in ctx.attr.deps:
        lib = d[RustLibrary]    
        transitive_rust_library_deps += lib.transitive_rust_library_deps

    emit_rust_compile_actions(
        ctx,  
        srcs = ctx.files.srcs,
        deps = ctx.attr.deps,
        transitive_rust_library_deps = transitive_rust_library_deps,
        crate_name = ctx.attr.name,
        crate_type = "bin",
        crate_root = find_crate_root(ctx, ctx.files.srcs, ["main.rs"]),
        out_object = ctx.outputs.executable,
    )
    
    return [
      RustBinary(
          executable = ctx.outputs.executable,
      ),
      DefaultInfo(
          files = depset([ctx.outputs.executable]),
      )
    ]

rust_binary = rule(
    _rust_binary_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = rust_filetype),
        "deps": attr.label_list(providers = [RustLibrary]),
    },
    executable = True,
    fragments = ["cpp"],
    toolchains = [TOOLCHAIN_TYPE],
)