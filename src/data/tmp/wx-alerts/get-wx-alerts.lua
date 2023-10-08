#!/usr/bin/lua
-- Program:  get-wx-alerts.lua
-- Purpose:  To retrieve any current NWS weather alerts and update the AAM wx.txt file
-- wx-alert-config.lua contains alert file path and weather zone to query
--   wx_alert_file   = "/tmp/aam/wx.txt"
--   wx_zone         = "AZZ548"

package.path = package.path .. ";/tmp/wx-alert/?.lua"

require("luci.jsonc")
require("aredn.utils")
require("nixio")
require("wx-alert-config")

-- Initialize the wx alert file
os.execute("cat /dev/null > " .. wx_alert_file)

-- Query weather.gov API for zone alerts
local wx = {}
wx = capture("/usr/bin/curl --silent --retry 3 --connect-timeout " .. connect_timeout .. " --speed-time " .. speed_time .. " --speed-limit " .. speed_limit .. " https://api.weather.gov/alerts/active?zone=" .. wx_zone .. " 2> /dev/null")
if wx then
  local wxalerts = luci.jsonc.parse(wx)
  if wxalerts.features[1] then   -- Has WX alert info
--    print(wxalerts.title)
--    print(wxalerts.features[1].properties.headline)
    local f = io.open(wx_alert_file, "w")
    if f then
      f:write(wxalerts.title .. "<br>" .. wxalerts.features[1].properties.headline )
      f:close()
    end
--  else   -- No WX alert info
--    print(wxalerts.title .. " - No current weather alerts")
  end

--else   -- Was not able to contact the NWS api
--  print("Unable to contact NWS api")

end

