directory '/opt/node_exporter'

remote_file '/opt/node_exporter/node_exporter-0.18.1.linux-armv6.tar.gz' do
  source 'https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-armv6.tar.gz'
  action :create_if_missing
  notifies :run, 'execute[extract_node_exporter]', :immediately
end

execute 'extract_node_exporter' do
  action :nothing
  command 'tar -zxf /opt/node_exporter/node_exporter-0.18.1.linux-armv6.tar.gz -C /opt/node_exporter'
end

link '/usr/bin/node_exporter' do
  to '/opt/node_exporter/node_exporter-0.18.1.linux-armv6/node_exporter'
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
