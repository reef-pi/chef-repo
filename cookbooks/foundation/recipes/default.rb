package %w(strace vim htop tree git curl screen net-tools lsof)

service 'ssh' do
  action [:start, :enable]
end

service 'systemd-timesyncd' do
  action [:start, :enable]
end

service 'bluetooth' do
 action [:stop, :disable]
end

service 'cups' do
 action [:stop, :disable]
end

service 'chef-client' do
 action [:stop, :disable]
end

timezone node['foundation']['timezone']



systemd_unit 'chef-client-ondemand.service' do
  bin_path =  ::File.exist?('/opt/chef/bin/chef-client') ? '/opt/chef/bin/chef-client':'/opt/cinc/bin/chef-client'
   content(
     'Unit' => { 'Description' => 'Ondemand chef-client run' },
     'Install' => { 'WantedBy' => 'multi-user.target' },
     'Service' =>{
      'Type'=> 'oneshot',
       'ExecStart' => bin_path
     }
  )
  action [:create]
end

systemd_unit 'chef-client.timer' do
   verify false
   content(
     'Unit' => { 'Description' => 'chef-client periodic run' },
     'Install' => { 'WantedBy' => 'timers.target' },
     'Timer' => {
       'OnBootSec' => '2min',
       'OnUnitInactiveSec' => "6h",
       'RandomizedDelaySec' => "30sec",
       'Unit' => 'chef-client-ondemand.service',
    }
  )
  action [:create, :start, :enable]
end
