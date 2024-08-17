rule("linkrule")
    on_config(function (target)
        target:add("shflags", "/DELAYLOAD:bedrock_runtime.dll")
    end)
    before_link(function (target)
        import("lib.detect.find_file")
        os.mkdir("$(buildir)/.prelink/lib")

        local data = assert(find_file("bedrock_runtime_data", {"$(env PATH)"}), "Cannot find bedrock_runtime_data")
        local link = assert(find_file("prelink.exe", {"$(env PATH)"}), "Cannot find prelink.exe")

        import("core.project.config")

        os.runv(link, table.join({vformat("%s-%s-%s", config.get("target_type") or "server", config.get("plat"), config.get("arch")), vformat("$(buildir)/.prelink"), data}, target:objectfiles()))
        target:add("linkdirs", "$(buildir)/.prelink/lib")
        target:add("shflags", "bedrock_runtime_api.lib", {force = true})
        target:add("shflags", "bedrock_runtime_var.lib", {force = true})
    end)
    after_link(function (target)
        
    end)
rule_end()
