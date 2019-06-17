package("patch")

    set_kind("binary")
    set_homepage("http://www.gnu.org/software/patch/patch.html")
    set_description("GNU patch, which applies diff files to original files.")

    if is_host("windows") then
        add_urls("https://gitlab.com/xmake-mirror/patch/uploads/2ff76c0c6a35a4a6af98bb7052544c38/patch-$(version)-bin.zip")
        add_urls("https://github.com/xmake-mirror/patch/releases/download/v2.5.9/patch-$(version)-bin.zip")
        add_versions("2.5.9-7", "fabd6517e7bd88e067db9bf630d69bb3a38a08e044fa73d13a704ab5f8dd110b")
    else
        add_urls("https://ftp.gnu.org/gnu/patch/patch-$(version).tar.bz2", {alias = "gnuftp"})
        add_urls("https://github.com/xmake-mirror/patch/archive/v$(version).tar.gz", {alias = "github"})
        add_versions("gnuftp:2.7.6", "3d1d001210d76c9f754c12824aa69f25de7cb27bb6765df63455b77601a0dcc9")
        add_versions("github:2.7.6", "33d5a86bad9813b27dbbe890123d0b88fbcc74d5d997aeadde60c670a2bd0eb9")
    end

    on_install("@windows", function (package)
        os.cp("bin/*", package:installdir("bin"))
    end)

    on_install("@macosx", "@linux", function (package)
        import("package.tools.autoconf").install(package)
    end)

    on_test(function (package)
        os.vrun("patch --version")
    end)
