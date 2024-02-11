# Variables
$splunkInstaller = "C:\Desktop\splunkforwarder-8.2.1-ae6821b7c64b-x64-release.msi"
$inputsConfPath = "C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf"
$outputsConfPath = "C:\Program Files\SplunkUniversalForwarder\etc\system\local\outputs.conf"

# Install Splunk Universal Forwarder
Start-Process -FilePath msiexec -ArgumentList "/i $splunkInstaller /quiet" -Wait

# Configure inputs.conf
[monitor://C:\Windows\System32\winevt\Logs\Microsoft-Windows-DNSServer%4Analytical.etl]
sourcetype = dns_log
index = main

[monitor://C:\Windows\System32\dhcp\DhcpSrvLog-*.log]
sourcetype = dhcp_log
index = main

[monitor://C:\Windows\System32\winevt\Logs\Directory Service]
sourcetype = ad_log
index = main

# Configure outputs.conf
@"
[tcpout]
defaultGroup = WinADdns

[tcpout:WinADdns]
server = 172.20.241.20:9997
"@ | Set-Content -Path $outputsConfPath -Force

# Start Splunk Universal Forwarder service
Start-Service -Name SplunkForwarder
