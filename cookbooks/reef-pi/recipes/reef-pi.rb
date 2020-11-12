require 'yaml'

extend ReefPiHelper


deb_pkg = installer_name
deb_url = installer_url

directory '/opt/reef-pi'

remote_file "/opt/reef-pi/#{deb_pkg}" do
  source  deb_url
  notifies :run, 'execute[install-reef-pi]', :immediately
end

execute 'install-reef-pi' do
  command "dpkg -i /opt/reef-pi/#{deb_pkg}"
  action :nothing
end

file '/etc/reef-pi/reef-pi.yaml' do
  content({
    'database' => '/var/lib/reef-pi/reef-pi.db'
  }.to_yaml)
end

systemd_unit 'reef-pi.service' do
  content({
    Unit: {
     Description: 'reef-pi - A raspberry pi based reef tank controller',
    },
    Service: {
      ExecStart: '/usr/bin/reef-pi daemon -config /etc/reef-pi/config.yml',
      WorkingDirectory: '/var/lib/reef-pi',
      Restart: 'always',
      RestartSec: 90,
      StartLimitInterval: 400,
      StartLimitBurst: 10,
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  })
  action [:create, :start, :enable]
end
