"""
Toolchain rules used by rust
"""

TOOLCHAIN_TYPE = "@new_rules_rust//rust:toolchain"

def get_rust_toolchain(ctx):
    return ctx.toolchains[TOOLCHAIN_TYPE]


def _rust_toolchain_impl(ctx):
    return [platform_common.ToolchainInfo(
      type = Label(TOOLCHAIN_TYPE),
      name = ctx.label.name,

      rustc = ctx.executable.rustc,
      rustc_lib = ctx.files.rustc_lib,
      rust_lib = ctx.files.rust_lib,

      crosstool = ctx.files.crosstool,
  )]

rust_toolchain_core_attrs = {
    "rustc": attr.label(mandatory = True, allow_files = True, single_file = True, executable = True, cfg = "host"),
    "rustc_lib": attr.label(mandatory = True, allow_files = True),
    "rust_lib": attr.label(mandatory = True, allow_files = True),

}

rust_toolchain_attrs = rust_toolchain_core_attrs + {
    "crosstool": attr.label(default=Label("//tools/defaults:crosstool")),
}

rust_toolchain = rule(
    _rust_toolchain_impl,
    attrs = rust_toolchain_attrs,
)
