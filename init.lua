local flstudio = require("flstudio")
flstudio.start()

-- Log the name of the active application to confirm appName
hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
        hs.alert.show("Active Application: " .. appName)
        print("Active Application: " .. appName)  -- Logs to Hammerspoon console
    end
end):start()
