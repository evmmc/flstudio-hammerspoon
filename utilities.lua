-- utilities.lua
local utilities = {}

-- Hammerspoon: Empty Trash instantly, system-wide
hs.hotkey.bind({"cmd", "alt", "shift"}, "delete", function()
    hs.osascript.applescript([[
        tell application "Finder"
            empty the trash without asking
        end tell
    ]])
    hs.notify.new({title="Hammerspoon", informativeText="Trash Emptied Instantly"}):send()
end)


-- Log the name of the active application to confirm appName
hs.application.watcher.new(function(appName, eventType, app)
    if eventType == hs.application.watcher.activated then
        hs.alert.show("Active Application: " .. appName)
        print("Active Application: " .. appName)  -- Logs to Hammerspoon console
    end
end):start()

-- Hammerspoon: run "doom +everywhere" with Ctrl+Alt+D
hs.hotkey.bind({"ctrl", "cmd"}, "=", function()
    hs.execute("doom +everywhere", true)  -- true = capture output (optional)
end)

return utilities
