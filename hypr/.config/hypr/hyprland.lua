-- Entry point. Each require() runs in its own scope, so an error in one
-- module does not stop the others from loading.

-- Machine-specific settings (monitors, scale) live in machine.lua,
-- which is not tracked by git. Guard it so a fresh machine still boots.
local f = io.open(os.getenv("HOME") .. "/.config/hypr/machine.lua", "r")
if f then
  f:close()
  require("machine")
else
  hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })
end

require("look")
require("binds")
require("rules")
require("autostart")
