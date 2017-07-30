load("@new_rules_rust//rust/private:common.bzl", "rust_filetype")
load("@new_rules_rust//rust/private:rust_toolchain.bzl", "TOOLCHAIN_TYPE")
load("@new_rules_rust//rust/private:providers.bzl", "RustLibrary")
load("@new_rules_rust//rust/private:compile.bzl", "emit_rust_compile_actions", "find_crate_root")


def _rust_library_impl(ctx):
    out_object = ctx.new_file("lib" + ctx.label.name + ".rlib")
    
    crate_name = ctx.attr.name
    crate_type = "lib"

    transitive_rust_library_deps = depset()

    for d in ctx.attr.deps:
        lib = d[RustLibrary]    
        transitive_rust_library_deps += lib.transitive_rust_library_deps
        transitive_rust_library_deps += [lib]

    emit_rust_compile_actions(
        ctx, 
        srcs = ctx.files.srcs,
        deps = ctx.attr.deps,
        crate_name = crate_name,
        crate_type = crate_type,
        crate_root = find_crate_root(ctx, ctx.files.srcs),
        out_object = out_object,
    )
    
    return [
      RustLibrary(
          label = ctx.label,
          library = out_object,
          crate_name = crate_name,
          crate_type = crate_type,
          transitive_rust_library_deps = transitive_rust_library_deps,
      ),
      DefaultInfo(
          files = depset([out_object]),
      )
    ]



rust_library = rule(
    _rust_library_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = rust_filetype),
        "deps": attr.label_list(providers = [RustLibrary]),
    },
    fragments = ["cpp"],
    toolchains = [TOOLCHAIN_TYPE],
)