-- utilities.lua
local utilities = {}
-- === Focus or Open Finder ===
--
-- This function checks if a Finder window is already open.
-- - If yes, it brings Finder to the front (activates it).
-- - If no, it opens a new Finder window at the user's home directory.
--
local function focusOrOpenFinder()
  local finder = hs.application.find("Finder")

  -- Check if Finder is running and has at least one window.
  if finder and #finder:allWindows() > 0 then
    -- If so, just bring it to the front.
    finder:activate()
  else
    -- Otherwise, run a simple AppleScript to open a new window at the home folder.
    -- This will also launch Finder if it's not running.
    hs.osascript.applescript('tell application "Finder" to open home')
  end
end

-- Bind the function to the shortcut: CMD + CTRL + 9
hs.hotkey.bind({"cmd", "ctrl"}, "9", function()
  focusOrOpenFinder()
end)

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
hs.hotkey.bind({"ctrl", "cmd", "opt"}, "e", function()
    hs.execute("doom +everywhere", true)  -- true = capture output (optional)
end)
-- =============================================================================
-- == Unified Modal for System Actions (CMD+CTRL+ALT+M)
-- =============================================================================
-- This creates a single "command mode" for various system actions.
-- Pressing CMD+CTRL+ALT+M enters the mode, after which you can press a
-- single key to trigger a specific action.

-- 1. Create the single, master modal object.
local masterModal = hs.hotkey.modal.new()

-- 2. Bind actions to keys within the modal.
-------------------------------------------

-- Press 'H' (for Hammerspoon) to reload the configuration.
masterModal:bind({}, "h", function()
  masterModal:exit() -- Crucial: always exit the modal after an action
  hs.reload()
  hs.notify.new({title="Hammerspoon", informativeText="Config Reloaded"}):send()
end)

-- Press 'S' (for Shazam) to run the "Shazam to Note" macOS Shortcut.
masterModal:bind({}, "s", function()
  masterModal:exit()
  hs.notify.new({title="Hammerspoon", informativeText="Running 'Shazam to Note'..."}):send()
  hs.task.new("/usr/bin/shortcuts", nil, {"run", "Shazam to Note"}):start()
end)

-- show binds
masterModal:bind({}, "c", function()
  masterModal:exit()
  show_active_config() -- This function is defined in the hotkey management section
end)

-- 3. Define the single "entry" hotkey that activates the modal.
---------------------------------------------------------------
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "m", function()
  masterModal:enter()
  -- Optional: provide a hint about what can be pressed.
  hs.notify.new({
    title="Binds in Modal Mode",
    informativeText="Press key: H (reload), S (Shazam), ? (help)"
  }):send()
end)

return utilities
