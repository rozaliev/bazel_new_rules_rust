def _rust_repo_impl(ctx):
    ctx.download_and_extract(
      url = ctx.attr.url,
      stripPrefix = ctx.attr.strip_prefix,
      sha256 = ctx.attr.sha256
    )
    ctx.template(
      "BUILD.bazel", 
      Label("@new_rules_rust//rust/private:repo.tpl.bazel"),
      substitutions = {}, 
      executable = False,
    )

rust_repo = repository_rule(
    implementation = _rust_repo_impl, 
    attrs = {
        "url" : attr.string(),
        "strip_prefix" : attr.string(),
        "sha256" : attr.string(),
    },
)