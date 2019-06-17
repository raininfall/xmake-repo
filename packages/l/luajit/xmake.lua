package("luajit")

    set_homepage("http://luajit.org")
    set_description("A Just-In-Time Compiler (JIT) for the Lua programming language.")

    set_urls("http://luajit.org/download/LuaJIT-$(version).tar.gz",
             "http://luajit.org/git/luajit-2.0.git",
             "http://repo.or.cz/luajit-2.0.git")

    add_versions("2.0.0", "deaed645c4a093c5fb250c30c9933c9131ee05c94b13262d58f6e0b60b338c15")
    add_versions("2.0.1", "2371cceb53453d8a7b36451e6a0ccdb66236924545d6042ddd4c34e9668990c0")
    add_versions("2.0.2", "c05202974a5890e777b181908ac237625b499aece026654d7cc33607e3f46c38")
    add_versions("2.0.3", "55be6cb2d101ed38acca32c5b1f99ae345904b365b642203194c585d27bebd79")
    add_versions("2.0.4", "620fa4eb12375021bef6e4f237cbd2dd5d49e56beb414bee052c746beef1807d")
    add_versions("2.0.5", "874b1f8297c697821f561f9b73b57ffd419ed8f4278c82e05b48806d30c1e979")

    add_includedirs("include/luajit")
    if not is_plat("windows") then
        add_syslinks("dl")
    end

    on_load(function (package)
        if is_plat("windows") then
            package:addenv("PATH", "lib")
        end
        package:addenv("PATH", "bin")
    end)

    on_install("windows", function (package)
        os.cd("src")
        os.vrun("msvcbuild.bat %s", package:debug() and "debug" and "")
        os.cp("luajit.exe", package:installdir("bin"))
        os.cp("lua51.lib", package:installdir("lib"))
        os.cp("lua51.dll", package:installdir("lib"))
        os.cp("*.h", package:installdir("include/luajit"))
    end)

    on_install("macosx", "linux", function (package)
        io.gsub("./Makefile", "export PREFIX= /usr/local", "export PREFIX=" .. package:installdir())
        if package:debug() then
            io.gsub("./src/Makefile", "CCDEBUG=", "CCDEBUG= -g")
        end
        os.vrun("make")
        os.cp("src/luajit", package:installdir("bin"))
        os.cp("src/*.a", package:installdir("lib"))
        os.cp("src/*.h", package:installdir("include/luajit"))
    end)

    on_test(function (package)
        print(os.getenv("PATH"))
        os.vrun("luajit -e \"print('hello xmake!')\"")
        assert(package:has_cfuncs("lua_pcall", {includes = "luajit.h"}))
    end)
