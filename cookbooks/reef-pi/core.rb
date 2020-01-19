service 'ssh' do
  action [:start, :enable]
end

service 'systemd-timesyncd' do
  action [:start, :enable]
end

service 'bluetooth' do
 action [:stop, :disable]
end

service 'chef-client' do
 action [:stop, :disable]
end

file '/etc/timezone' do
  content 'US/Pacific'
end
