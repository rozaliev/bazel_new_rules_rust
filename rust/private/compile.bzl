load("@new_rules_rust//rust/private:rust_toolchain.bzl", "get_rust_toolchain")
load("@new_rules_rust//rust/private:providers.bzl", "RustLibrary")

CRATE_TYPES = ["bin","lib","rlib","dylib","cdylib","staticlib","proc-macro"]

def find_crate_root(ctx, srcs, good = ["lib.rs"]):
    if len(srcs) == 1:
        return srcs[0].path
    
    for s in srcs:
        if s.basename in good:
            return s.path

    fail("rust_library %s: can't find crate root. library has multiple files, but has no 'lib.rs'" % ctx.attr.name) 

def emit_rust_compile_actions(ctx, srcs, deps, crate_name, crate_type, crate_root, out_object, transitive_rust_library_deps = [],):
    if not crate_type in CRATE_TYPES:
        fail("unkown crate type: %s" % crate_type)

    toolchain = get_rust_toolchain(ctx)
    cpp_fragment = ctx.fragments.cpp

    cc = cpp_fragment.compiler_executable
    ar = cpp_fragment.ar_executable
    

    inputs = srcs + toolchain.crosstool
    args = []
    
    rustc_lib_dir = toolchain.rustc_lib[0].dirname
    env = {
        "LD_LIBRARY_PATH": rustc_lib_dir,
        "DYLD_LIBRARY_PATH":  rustc_lib_dir,
    }

    out_dir = out_object.dirname

    deps_args = []
    for d in deps:
        lib = d[RustLibrary]
        deps_args += ["--extern", "%s=%s" % (lib.crate_name,lib.library.path)]
        inputs += [lib.library]


    trans_deps_args = []
    for d in transitive_rust_library_deps:
        trans_deps_args += ["-L", "dependency=%s" % d.library.dirname]


    args += ["--color", "always"]
    args += ["--crate-name", crate_name]
    args += [crate_root]
    args += ["--crate-type", crate_type]
    args += ["--emit=dep-info,link"]
    args += ["-L", "all=%s" % toolchain.rust_lib[0].dirname]
    args += ["--out-dir", out_dir]
    args += ["-C", "opt-level=3"]
    args += ["--codegen", "ar=%s" % ar]
    args += ["--codegen", "linker=%s" % cc]


    args += deps_args
    args += trans_deps_args


    ctx.actions.run(
      outputs = [out_object],
      inputs = inputs,
      mnemonic = "RustCompile",
      executable = toolchain.rustc,
      env = env,
      arguments = args,
  )