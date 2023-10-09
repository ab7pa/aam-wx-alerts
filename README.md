# AREDN Alert Messages
## National Weather Service Alerts by Zone

This package adds a program to ``/etc/cron.hourly`` which will query the National Weather Service API for a specific *Zone* every hour. If active alert messages are found, the ``/www/aam/wx.txt`` file on the node is updated with the alert text. You can find your local NWS *Zone* by searching at the following URL: https://alerts.weather.gov

To query alerts for your zone, login to your node at the command line and edit the ``/etc/cron.hourly/get-wx-alerts`` file. Change the ``wx_zone`` variable to your NWS *Zone* identifier. This program assumes your node has Internet access on its WAN.

This program allows your node to function as an AREDN Alert Message source. Any other local node may opt to receive your NWS alert messages by adding your node's URL (``http://<nodename>.local.mesh:8080/aam``) to its **Alert Message Local URL** field, as well as entering ``wx`` in the **Alert Message Groups** field.
