package 'reef-pi'

file '/etc/reef-pi/reef-pi.yaml' do
  content({
    'database' =>  '/var/lib/reef-pi/reef-pi.db'
  }.to_yaml)
end

service 'reef-pi' do
  action [:start, :enable]
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
