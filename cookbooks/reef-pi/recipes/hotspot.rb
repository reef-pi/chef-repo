%w(bridge-utils nftables dnsmasq hostapd).each do |pkg|
  package pkg
end

template '/etc/dhcpcd.conf' do
  variables(
   subnet: '192.168.4.1/24'
  )
  owner 'root'
  group 'netdev'
  mode 0644
end

file '/etc/dnsmasq.conf' do
  content(
'interface=wlan0
dhcp-range=192.168.4.2,192.168.4.20,255.255.255.0,24h
')
  owner 'root'
  group 'root'
  mode 0644
end

template '/etc/hostapd/hostapd.conf' do
  variables(
    ssid: 'reef-pi',
    wpa_passphrase: 'reef-pi'
  )
  owner 'root'
  group 'root'
  mode 0644
end

file '/etc/default/hostapd' do
  content 'DAEMON_CONF="/etc/hostapd/hostapd.conf"'
end

service 'dnsmasq' do
  action [ :stop, :disable]
end

service 'hostapd' do
  action [ :stop, :disable]
end

service 'dhcpcd' do
  action [ :stop, :disable]
end
