pkg_name=tor
pkg_version=0.3.2.9
pkg_origin=core
pkg_license=('BSD-3-Clause')
pkg_description="Free software and an open network that helps you defend against traffic analysis"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_upstream_url="https://www.torproject.org/"
pkg_source="https://www.torproject.org/dist/tor-${pkg_version}.tar.gz"
pkg_shasum=435a7b91aa98d8b1a0ac1f60ca30c0ff3665b18a02e570bab5fe27935829160f
pkg_deps=(
  core/glibc
  core/gcc-libs
  core/libevent
  core/openssl
  core/zlib
  core/libseccomp
  core/libscrypt)
pkg_build_deps=(core/gcc core/make core/pkg-config core/python)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_bin_dirs=(bin)
pkg_svc_run="tor -f $pkg_svc_config_path/torrc"
pkg_exports=(
  [port]=socks_bind_port
)
pkg_exposes=(port)

do_build() {
   # Enabling -02 avoids hundreds of warnings about _FORTIFY_SOURCE
   export CFLAGS="-O2 ${CFLAGS}"
   # -lgcc_s seems to be needed to dlopen libgcc_s.so
   # It is unclear to me why this is needed since the RUNPATH tag in the elf binary
   # contains the path that includes libgcc_s.so
   export LDFLAGS="-lgcc_s ${LDFLAGS}"
   ./configure --prefix="${pkg_prefix}" --disable-dependency-tracking
   make
}

do_check() {
  make test
}
