using BinaryProvider, Libdl

## NOTE: This is not a typical build.jl file; it has extra stuff toward the bottom.
## Don't just replace this file with the output of a BinaryBuilder repository!

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))
products = [
    LibraryProduct(prefix, ["libarpack"], :libarpack),
]

# Download binaries from hosted location
bin_prefix = "https://github.com/JuliaLinearAlgebra/ArpackBuilder/releases/download/v3.5.0-3"

# Listing of files generated by BinaryBuilder:
download_info = Dict(
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-gnu-gcc4.tar.gz", "d19fd4f1aa62c189f93462cbe25d6765c2ad42f8762d6c374e9e4e916f573aba"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-gnu-gcc7.tar.gz", "66242daa33cfeeb2085ffb1c374e93642bca3f2a5dc61f864d214c041441d25d"),
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-gnu-gcc8.tar.gz", "33245806067e5f96f4ad0b5070b52296e0f92b474fbfc9e4c0790253013ff127"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-musl-gcc4.tar.gz", "f8858dd20c7fd83dca71616be8adf1b2e3e86a7ece7e3ec52e05867da2290364"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-musl-gcc7.tar.gz", "a23b510a9fe2a78469c8d942f498ff1729bd9d7da9ceafda8318acf6a0057da0"),
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.aarch64-linux-musl-gcc8.tar.gz", "75f08c85072c4ae6d2d004efb99a6f9202e139746b120fa59e9c82fcdc207427"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-gnueabihf-gcc4.tar.gz", "d0601f37d571dff33f810aa3c2ba724c4cd163c17cbc57eb001057992cf01973"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-gnueabihf-gcc7.tar.gz", "c366fe80bdb3f705ebb5ddbd25267376e34085633931441ff50e0f0793c53dd5"),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-gnueabihf-gcc8.tar.gz", "ea83ae4112c39cfec4fc317520827d0a89c61dfe01d1ecbf21b7349aa135035a"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-musleabihf-gcc4.tar.gz", "164150c704b4db50662987a05e23d0581e72157ca56cc9389a68ebfd242baef9"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-musleabihf-gcc7.tar.gz", "5b83bf6dac70d9ad492d69a4ca08a6b2efa0e80ddd59b4c44ec0db6169a01384"),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.arm-linux-musleabihf-gcc8.tar.gz", "398d5b42ae1a631264f680c7133e27ff17396e5a7cf9a4830b54e3f88b06052f"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-gnu-gcc4.tar.gz", "624c7b4e9ff830c8ebd88ead20250f02b9a2cbcd78b83b2e350d1d53abb3bdc3"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-gnu-gcc7.tar.gz", "be5022190cb3365e5e3e43354c13c6adb245f4529d18b97b4efd6dea5fdb36e8"),
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-gnu-gcc8.tar.gz", "b110c5ccb564f0617efb57cefbd46459a4830fbaa390f225167561b73b694081"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-musl-gcc4.tar.gz", "8835f810f27661813e1fdb0fa02540215b02b5a6205a45dad6d02d00de82ca4c"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-musl-gcc7.tar.gz", "9e3d16c23eb539f2345d5ebc7dc5df2a8a3236ae02492d13de50e3759cbbb6be"),
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-linux-musl-gcc8.tar.gz", "4db9a56c70c4cd5d55101c13250e800476b9cd6160a53249821cb00618b00b34"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-w64-mingw32-gcc4.tar.gz", "0a6b238b843491fa2dd783ddcc440d82f4d295ab33f91ce1a0c80835fa7805e2"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-w64-mingw32-gcc7.tar.gz", "17471e4289c7393e499ca3066e32f1a8776d1aad1fa994c9ec4398275be6e3cd"),
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.i686-w64-mingw32-gcc8.tar.gz", "c2da0cc187bdca8edee8bc3528c29f80c8a70eef165b449bcefe62b9affe51c5"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.powerpc64le-linux-gnu-gcc4.tar.gz", "dbb601c9c34d27fdbd74829874620e3dcf325bb05a3584d1be22b45bae3c1376"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.powerpc64le-linux-gnu-gcc7.tar.gz", "762601ab49f9d5ca5702968f167ce1a04b14ba8dc02d6a61bf7650c006c5bb42"),
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.powerpc64le-linux-gnu-gcc8.tar.gz", "efc2337f3a911377cf018d1827d9cd65f2314e1a81e000f92cb21b8b7fd6aa57"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-apple-darwin14-gcc4.tar.gz", "7ef977fd7214bbb96b57eb852da6e9227a89ea168403a23d0feb1602e77ade43"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-apple-darwin14-gcc7.tar.gz", "282bc463663328dd7f613b43b84459a7b87f59e61ceff780e8a606026613b67f"),
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-apple-darwin14-gcc8.tar.gz", "78295ca3721b22db9e76760676a7157c13ec3125e276c7da571a0d5fc5858929"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-gnu-gcc4.tar.gz", "137a1617ff1c9bb64080fa0a36103294c2670568a00ae6a953307fb0625cdb46"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-gnu-gcc7.tar.gz", "35e2f96333bfde0fb1749bf2f7d9a84fa8dfac6119d60a84a6b274d42dd85037"),
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-gnu-gcc8.tar.gz", "11ae0abf2e42fa19364391bd9994c321aceb6604b204a62b062766f68ff7ef60"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-musl-gcc4.tar.gz", "0a01691c184c6251521a54d24d8095210fa79d6ea4cc5d6777e4b45d1d4390e7"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-musl-gcc7.tar.gz", "a40c92a2799b42605e0ccb17806b66bb1e1c848934a6d7fb7498df4aeaa29d9d"),
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-linux-musl-gcc8.tar.gz", "235e3816d930ef1552456586cb93cff798ee240f05561a42ac9e79eb0dc84a9a"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-unknown-freebsd11.1-gcc4.tar.gz", "8b0f3e6219c5fdcd58a5b0c7bfac6141b613c5846f0536e6d621b312d88204ee"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-unknown-freebsd11.1-gcc7.tar.gz", "f69db95295c172cd4281339f9727f1abc4491171ef0f08632000ad87f9d90cf3"),
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-unknown-freebsd11.1-gcc8.tar.gz", "f8ea43eb0624f77ab18582cea9e21dbab6981320b14625eaf461b152be4ea1b9"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-w64-mingw32-gcc4.tar.gz", "017832f856354f156910bfd9db9c04671863d1ea1c761435917fff3e5863c0b8"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-w64-mingw32-gcc7.tar.gz", "28beddf5a3e178012f910e406897d2abdf70ff3373c4b946ac39eae61070d042"),
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => ("$bin_prefix/Arpack.v3.5.0-3.x86_64-w64-mingw32-gcc8.tar.gz", "1fc0035e5bd62448243f8ed09041dee6a2480ea23e648c47b9d56d1f467a0ca0"),
)


# Regenerate this with `get_default_blaslib_names.jl`
default_blaslib_names = Dict(
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => "libopenblas.so.0",
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so.0",
    Windows(:i686, compiler_abi=CompilerABI(:gcc7)) => "libopenblas.dll",
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.dylib",
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.dylib",
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => "libopenblas.so.0",
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so.0",
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => "libopenblas.so.0",
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc8)) => "libopenblas.so.0",
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so.0",
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so",
    Linux(:x86_64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so.0",
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so",
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.dll",
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.dll",
    Windows(:i686, compiler_abi=CompilerABI(:gcc4)) => "libopenblas.dll",
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so.0",
    MacOS(:x86_64, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.dylib",
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => "libopenblas.so.0",
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc7)) => "libopenblas.so.0",
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so.0",
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so.0",
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => "libopenblas.so.0",
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so.0",
    Linux(:armv7l, libc=:musl, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => "libopenblas.so.0",
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => "libopenblas.so.0",
    Windows(:i686, compiler_abi=CompilerABI(:gcc8)) => "libopenblas.dll",
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so.0",
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf, compiler_abi=CompilerABI(:gcc4)) => "libopenblas.so.0",
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so.0",
    Linux(:aarch64, libc=:glibc, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so.0",
    FreeBSD(:x86_64, compiler_abi=CompilerABI(:gcc4)) => "libopenblas64_.so",
    Linux(:powerpc64le, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so.0",
    Linux(:i686, libc=:glibc, compiler_abi=CompilerABI(:gcc8)) => "libopenblas.so.0",
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc8)) => "libopenblas64_.so.0",
    Linux(:x86_64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so.0",
    Windows(:x86_64, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.dll",
    Linux(:i686, libc=:musl, compiler_abi=CompilerABI(:gcc4)) => "libopenblas.so.0",
    Linux(:aarch64, libc=:musl, compiler_abi=CompilerABI(:gcc7)) => "libopenblas64_.so.0",
)

# Install unsatisfied or updated dependencies:
unsatisfied = any(!satisfied(p; verbose=verbose) for p in products)
dl_info = choose_download(download_info, platform_key_abi())
if dl_info === nothing && unsatisfied
    # If we don't have a compatible .tar.gz to download, complain.
    # Alternatively, you could attempt to install from a separate provider,
    # build from source or something even more ambitious here.
    error("Your platform (\"$(Sys.MACHINE)\", parsed as \"$(triplet(platform_key_abi()))\") is not supported by this package!")
end

# If we have a download, and we are unsatisfied (or the version we're
# trying to install is not itself installed) then load it up!
if unsatisfied || !isinstalled(dl_info...; prefix=prefix)
    # Download and install binaries
    install(dl_info...; prefix=prefix, force=true, verbose=verbose)

    # Distribution packagers love to rename their BLAS libraries, which is naturally
    # incompatible with precompiled binaries.  We attempt to address this by automatically
    # creating a symlink to the currently loaded BLAS library that is named what ARPACK is
    # attempting to load.
    blaslib = first(filter(x -> occursin(Base.libblas_name, x), dllist()))
    default_blaslib_name = choose_download(default_blaslib_names, platform_key_abi())
    if basename(blaslib) != default_blaslib_name && !isfile(joinpath(dirname(blaslib), default_blaslib_name))
        sym_file = joinpath(abspath(joinpath(Sys.BINDIR, Base.LIBDIR)), default_blaslib_name)
        @warn(strip(replace(
        """
        This Julia installation uses a non-default BLAS library name (\"$(basename(blaslib))\"
        instead of \"$(default_blaslib_name)\")!  This is likely due to using a distribution
        package, and can cause problems when installing binary dependencies such as Arpack.jl.
        We will attempt to automatically map the distribution-provided BLAS library to such
        that libarpack can find it, but this may not work.  If issues with Arpack.jl persist,
        we recommend using the Julia binaries available for download from the official website
        at https://julialang.org/downloads.html
        """, '\n' => ' ')))

        @warn(strip(replace(
        """
        Attempting to symlink \"$(sym_file)\" => \"$(blaslib)\"; if this fails, try running it
        manually with super user permissions via: sudod ln -s $(blaslib) $(sym_file)
        """, '\n' => ' ')))
        symlink(blaslib, sym_file)
    end
end

# Write out a deps.jl file that will contain mappings for our products
write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=verbose)
