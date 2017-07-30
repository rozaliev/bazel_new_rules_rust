load("@new_rules_rust//rust/toolchain:toolchains.bzl", "register_rust_toolchains")
load("@new_rules_rust//rust/private:repo.bzl", "rust_repo")

_repos = {
    "rust-1.19.0-x86_64-unknown-linux-gnu.tar.gz": "",
    "rust-1.19.0-x86_64-apple-darwin.tar.gz": "",
}


_SUFFIX = ".tar.gz"

def rust_repositories():
    register_rust_toolchains()

    for filename, sha256 in _repos.items():
        name = filename[len("rust-"):-len(_SUFFIX)]
        name = "rust_stable_" + name.replace("-","_").replace(".","_")
        strip_prefix =  filename[:-len(_SUFFIX)]
        rust_repo(
            name = name,
            url = "https://static.rust-lang.org/dist/" + filename,
            sha256 = sha256,
            strip_prefix = strip_prefix,
        )

