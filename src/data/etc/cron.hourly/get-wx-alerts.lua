#!/usr/bin/lua
-- Program:  get-wx-alerts.lua
-- Purpose:  To retrieve any current NWS weather alerts for a zone and update /www/wx.txt

require("luci.jsonc")
require("aredn.utils")
require("nixio")

-- Initialize variables and wx_alert_file
wx_alert_file   = "/www/aam/wx.txt"
--wx_zone         = "AZZ548"
wx_zone         = "AKZ332"
connect_timeout = 5
speed_time      = 10
speed_limit     = 1000
os.execute("cat /dev/null > " .. wx_alert_file)

-- Query weather.gov API for zone alerts
local wx = {}
wx = capture("/usr/bin/curl --silent --retry 3 --connect-timeout " .. connect_timeout .. " --speed-time " .. speed_time .. " --speed-limit " .. speed_limit .. " https://api.weather.gov/alerts/active?zone=" .. wx_zone .. " 2> /dev/null")
if wx then
  local wxalerts = luci.jsonc.parse(wx)
  if wxalerts.features[1] then   -- Has WX alert info
    local f = io.open(wx_alert_file, "w")
    if f then
      f:write(wxalerts.title .. "<br>" .. wxalerts.features[1].properties.headline )
      f:close()
    end
  end
end
