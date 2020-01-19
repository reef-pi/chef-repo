systemd_unit 'nodeexporter.service' do
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
