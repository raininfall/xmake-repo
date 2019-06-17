package("gtest")

    set_kind("static")
    set_homepage("https://github.com/google/googletest")
    set_description("Google Testing and Mocking Framework")

    set_urls("https://github.com/google/googletest.git")
    add_versions("1.8.1", "release-1.8.1")

    on_install(function (package)
        import("package.tools.cmake").install(package)
        os.cp("googletest/include/", package:installdir())
    end)

