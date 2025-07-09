-- flstudio.lua
local flstudio = {}

-- Table to store FL Studio hotkeys
local flStudioHotkeys = {}

-- Function to activate hotkeys when FL Studio is active
function flstudio.activateHotkeys()
    -- Settings
    flStudioHotkeys[1] = hs.hotkey.bind({"cmd"}, ",", function()
        hs.eventtap.keyStroke({}, "F10")
    end)
    -- Mixer
    flStudioHotkeys[2] = hs.hotkey.bind({"cmd"}, "m", function()
        hs.eventtap.keyStroke({}, "F9")
    end)
    -- Channel rack
    flStudioHotkeys[3] = hs.hotkey.bind({"cmd"}, "r", function()
        hs.eventtap.keyStroke({}, "F6")
    end)
    -- Playlist
    flStudioHotkeys[4] = hs.hotkey.bind({"cmd"}, "p", function()
        hs.eventtap.keyStroke({}, "F5")
    end)
    -- Help
    flStudioHotkeys[5] = hs.hotkey.bind({"cmd", "shift", "alt"}, "h", function()
        hs.eventtap.keyStroke({}, "F1")
    end)
    -- Piano roll
    flStudioHotkeys[6] = hs.hotkey.bind({"cmd", "ctrl"}, "r", function()
        hs.eventtap.keyStroke({}, "F7")
    end)
    -- redo
    flStudioHotkeys[7] = hs.hotkey.bind({"cmd"}, "y", function()
        hs.eventtap.keyStroke({"cmd", "alt"}, "z")
    end)
    -- new named pattern
    flStudioHotkeys[8] = hs.hotkey.bind("F4", function()
        hs.eventtap.keyStroke({"cmd", "ctrl"}, "n")
    end)
    -- new unnamed pattern
    flStudioHotkeys[9] = hs.hotkey.bind({"cmd"}, "F4", function()
        hs.eventtap.keyStroke({"cmd", "ctrl"}, "m")
    end)
end

-- Function to deactivate hotkeys when FL Studio is inactive
function flstudio.deactivateHotkeys()
    for _, hotkey in ipairs(flStudioHotkeys) do
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
  hs.hotkey.bind({"cmd", "ctrl"}, fnKey, function()
    hs.eventtap.keyStroke({}, padKey)
  end)
end

-- Patterns 1–20 via Cmd+F1–F20
local patterns = {}
for i = 1, 20 do
  local fnKey = "F" .. i
  local padKey = "pad" .. i
  patterns[fnKey] = padKey
end

for fnKey, padKey in pairs(patterns) do
  hs.hotkey.bind({"cmd"}, fnKey, function()
    hs.eventtap.keyStroke({}, padKey)
    hs.notify.new({title="FL Studio", informativeText="Selected Pattern " .. string.sub(padKey, 4)}):send()
  end)
end

-- Cmd+Opt+1–8 → Pattern 13–20
for i = 1, 8 do
  local key = tostring(i)
  local patternNum = i + 12
  local padKey = "pad" .. patternNum

  hs.hotkey.bind({"cmd", "alt"}, key, function()
    hs.eventtap.keyStroke({}, padKey)
    hs.notify.new({title="FL Studio", informativeText="Selected Pattern " .. patternNum}):send()
  end)
end

-- Start the watcher
function flstudio.start()
    flstudio.watcher:start()
end

return flstudio
