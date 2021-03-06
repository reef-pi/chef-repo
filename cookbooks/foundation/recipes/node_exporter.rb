_arch = 'amd64'

case node['kernel']['machine']
when 'armv6l'
  _arch = 'armv6'
when 'armv7l'
  _arch = 'armv7'
end

directory '/opt/node_exporter'
_version = node['foundation']['node_exporter_version']

remote_file "/opt/node_exporter/node_exporter-#{_version}.linux-#{_arch}.tar.gz" do
  source "https://github.com/prometheus/node_exporter/releases/download/v#{_version}/node_exporter-#{_version}.linux-#{_arch}.tar.gz"
  action :create_if_missing
  notifies :run, 'execute[extract_node_exporter]', :immediately
  notifies :restart, 'systemd_unit[node_exporter.service]'
end

execute 'extract_node_exporter' do
  action :nothing
  command "tar -zxf /opt/node_exporter/node_exporter-#{_version}.linux-#{_arch}.tar.gz -C /opt/node_exporter"
end

link '/usr/bin/node_exporter' do
  to "/opt/node_exporter/node_exporter-#{_version}.linux-#{_arch}/node_exporter"
end

systemd_unit 'node_exporter.service' do
  content({
    Unit: {
      Description: 'NodeExporter'
    },
    Service: {
      TimeoutStartSec: 0,
      ExecStart: '/usr/bin/node_exporter'
    },
    Install: {
      WantedBy: 'multi-user.target'
    }
  })
  action [:create, :start, :enable]
end
