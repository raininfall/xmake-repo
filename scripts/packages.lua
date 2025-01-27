-- imports
import("core.package.package")
import("core.platform.platform")

-- is supported platform and architecture?
function _is_supported(instance, plat, arch, opt)

    -- get script
    local script = instance:get("install")
    local result = nil
    if type(script) == "function" then
        result = script
    elseif type(script) == "table" then

        -- get plat and arch
        local plat = plat or ""
        local arch = arch or ""

        -- match pattern
        --
        -- `@linux`
        -- `@linux|x86_64`
        -- `@macosx,linux`
        -- `android@macosx,linux`
        -- `android|armv7-a@macosx,linux`
        -- `android|armv7-a@macosx,linux|x86_64`
        -- `android|armv7-a@linux|x86_64`
        --
        for _pattern, _script in pairs(script) do
            local hosts = {}
            local hosts_spec = false
            _pattern = _pattern:gsub("@(.+)", function (v) 
                for _, host in ipairs(v:split(',')) do
                    hosts[host] = true
                    hosts_spec = true
                end
                return "" 
            end)
            if _pattern:trim() == "" and opt and opt.onlyhost then
                _pattern = os.host()
            end
            if not _pattern:startswith("__") and (not hosts_spec or hosts[os.host() .. '|' .. os.arch()] or hosts[os.host()])  
            and (_pattern:trim() == "" or (plat .. '|' .. arch):find('^' .. _pattern .. '$') or plat:find('^' .. _pattern .. '$')) then
                result = _script
                break
            end
        end

        -- get generic script
        result = result or script["__generic__"]
    end
    return result
end

-- the main entry
function main(opt)
    local packages = {}
    for _, packagedir in ipairs(os.dirs(path.join("packages", "*", "*"))) do
        local packagename = path.filename(packagedir)
        local packagefile = path.join(packagedir, "xmake.lua")
        local instance = package.load_from_repository(packagename, nil, packagedir, packagefile)
        if instance then
            for _, plat in ipairs({"windows", "linux", "macosx", "iphoneos", "android", "mingw"}) do
                local archs = platform.archs(plat)
                if archs then
                    local package_archs = {}
                    for _, arch in ipairs(archs) do
                        if _is_supported(instance, plat, arch, opt) then
                            table.insert(package_archs, arch)
                        end
                    end
                    if #package_archs > 0 then
                        packages[plat] = packages[plat] or {}
                        table.insert(packages[plat], {name = instance:name(), archs = package_archs, generic = #package_archs == #archs})
                    end
                end
            end
        end
    end
    for _, packages_plat in pairs(packages) do
        table.sort(packages_plat, function(a, b) return a.name < b.name end)
    end
    return packages
end
