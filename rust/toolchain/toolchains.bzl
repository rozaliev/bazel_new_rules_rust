load("@new_rules_rust//rust/private:rust_toolchain.bzl", "TOOLCHAIN_TYPE", "rust_toolchain")

_label_prefix = "@new_rules_rust//rust/toolchain:"


def _generate_toolchains():
    # os
    os_linux = struct(name="linux", constraint = "@bazel_tools//platforms:linux")
    os_darwin = struct(name="darwin", constraint = "@bazel_tools//platforms:osx")
    
    # arch
    arch_amd64 = struct(name="x86_64", constraint = "@bazel_tools//platforms:x86_64")

    # full set
    linux_amd64 = struct(os=os_linux, arch=arch_amd64, name="x86_64-unknown-linux-gnu")
    darwin_amd64 = struct(os=os_darwin, arch=arch_amd64, name="x86_64-apple-darwin")


    versions = [
        struct(
            version = [1,19,0],
            platforms = [linux_amd64, darwin_amd64],
        )
    ]



    toolchains = []

    for v in versions:
        channel = "stable"
        version = ".".join(v.version)
        version_underscore = "_".join(v.version)
        for p in v.platforms:
            host = p
            target = p
            toolchain_name = version + "_" + host.os.name + "_" + host.arch.name
            triple_underscore = p.name.replace("-","_")

            distribution = "@rust_%s_%s_%s" % (channel, version_underscore, triple_underscore)
            toolchain = dict(
                name = toolchain_name,
                impl = toolchain_name + "_impl",
                host = host,
                target = target,
                typ = TOOLCHAIN_TYPE,
                exec_constraints = [host.os.constraint, host.arch.constraint],
                target_constraints = [target.os.constraint, target.arch.constraint],

                rustc = distribution + "//:rustc",
                rustc_lib = distribution + "//:rustc_lib_" + target.arch.name + "_" + target.os.name,
                rust_lib = distribution + "//:rust_lib_" + target.arch.name + "_" + target.os.name,
            )
            

            toolchains += [toolchain]

    return toolchains


_toolchains = _generate_toolchains()

def register_rust_toolchains():
    for toolchain in _toolchains:
        native.register_toolchains(_label_prefix + toolchain["name"])

def declare_toolchains():
    for toolchain in _toolchains:
        rust_toolchain(
            name = toolchain["impl"],
            rustc = toolchain["rustc"],
            rustc_lib = toolchain["rustc_lib"],
            rust_lib = toolchain["rust_lib"]               
        )
        native.toolchain(
            name = toolchain["name"],
            toolchain_type = toolchain["typ"],
            exec_compatible_with = toolchain["exec_constraints"],
            target_compatible_with = toolchain["target_constraints"],
            toolchain = _label_prefix + toolchain["impl"],
        )
