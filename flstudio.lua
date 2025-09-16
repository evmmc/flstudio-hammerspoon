-- flstudio.lua
local flstudio = {}

-- Hammerspoon function: trigger "Remove all edisons" in FL Studio
function fl_remove_edisons()
  local app = hs.appfinder.appFromName("FL Studio")
  if app then
    app:selectMenuItem({"Tools", "Macros", "Remove all Edison instances"})
    hs.alert.show("🧹 Removed all Edisons")
  else
    hs.alert.show("FL Studio not running")
  end
end


-- Table to store FL Studio hotkeys
local flStudioHotkeys = {}
-- Function to activate hotkeys when FL Studio is active
function flstudio.activateHotkeys()
    -- Settings
    flStudioHotkeys[1] = hs.hotkey.bind({"cmd"}, ",", function()
        hs.eventtap.keyStroke({}, "F10")
    end)
    --  Channel rack
    -- Mixer
    flStudioHotkeys[2] = hs.hotkey.bind({"cmd"}, "m", function()
        hs.eventtap.keyStroke({}, "F9")
    end)

    flStudioHotkeys[13] = hs.hotkey.bind({"option", "shift"}, "i", function()
        hs.eventtap.keyStroke({"shift", "ctrl"}, "insert")
    end)
-- FL Studio pattern navigation
    flStudioHotkeys[14] = hs.hotkey.bind({"option"}, "p", function()
        hs.eventtap.keyStroke({}, "pad-")   -- previous pattern
    end)

    flStudioHotkeys[15] = hs.hotkey.bind({"option"}, "n", function()
        hs.eventtap.keyStroke({}, "pad+")   -- next pattern
    end)

    flStudioHotkeys[19] = hs.hotkey.bind({"cmd"}, "c", function()
        hs.eventtap.keyStroke({}, "F6")
    end)

    -- playlist
    flStudioHotkeys[20] = hs.hotkey.bind({"cmd"}, "p", function()
        hs.eventtap.keyStroke({}, "F5")
    end)

    -- Example: bind to Cmd+Alt+A
    flStudioHotkeys[21] = hs.hotkey.bind({"cmd", "option", "ctrl"}, "x", fl_remove_edisons)

end

-- Function to deactivate hotkeys when FL Studio is inactive
function flstudio.deactivateHotkeys()
    -- for _, hotkey in ipairs(flStudioHotkeys) do
    for _, hotkey in pairs(flStudioHotkeys) do
        hotkey:delete()
    end
    flStudioHotkeys = {}
end

-- Watcher to handle FL Studio activation and deactivation
flstudio.watcher = hs.application.watcher.new(function(appName, eventType, app)
    if appName == "FL Studio" and eventType == hs.application.watcher.activated then
        flstudio.activateHotkeys()
    elseif appName == "FL Studio" and eventType == hs.application.watcher.deactivated then
        flstudio.deactivateHotkeys()
    end
end)

-- Map Cmd + F1 to F9 → Numpad 1 to 9 (Pattern 1 to 9 in FL Studio)
local patternKeys = {
  F1 = "pad1",
  F2 = "pad2",
  F3 = "pad3",
  F4 = "pad4",
  F5 = "pad5",
  F6 = "pad6",
  F7 = "pad7",
  F8 = "pad8",
  F9 = "pad9"
}

for fnKey, padKey in pairs(patternKeys) do
  hs.hotkey.bind({"cmd", "ctrl", "opt"}, fnKey, function()
    hs.eventtap.keyStroke({}, padKey)
  end)
end

-- Start the watcher
function flstudio.start()
    flstudio.watcher:start()
end

return flstudio
