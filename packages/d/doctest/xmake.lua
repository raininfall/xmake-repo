package("doctest")

    set_homepage("http://bit.ly/doctest-docs")
    set_description("The fastest feature-rich C++11/14/17/20 single-header testing framework for unit tests and TDD")

    set_urls("https://github.com/onqtam/doctest.git")

    add_versions("2.3.1", "2.3.1")

    on_install(function (package)
        os.cp("doctest/", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            int factorial(int number) { return number <= 1 ? number : factorial(number - 1) * number; }

            TEST_CASE("testing the factorial function") {
                CHECK(factorial(1) == 1);
                CHECK(factorial(2) == 2);
                CHECK(factorial(3) == 6);
                CHECK(factorial(10) == 3628800);
            }
        ]]}, {configs = {languages = "c++11"}, includes = "doctest/doctest.h", defines = "DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN"}))
    end)
