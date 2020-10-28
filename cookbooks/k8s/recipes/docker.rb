apt_repository 'docker' do
   components %w(stable)
   uri "https://download.docker.com/linux/ubuntu"
   arch 'amd64'
   key "https://download.docker.com/linux/ubuntu/gpg"
end

package 'containerd.io' do
  version '1.2.13-2'
end

package 'docker-ce'

package 'docker-ce-cli'

dConf = {
  'exec-opts' => %w(native.cgroupdriver=systemd),
  'log-driver' => 'json-file',
  'log-opts'=> {
    'max-size' => '100m'
  },
  'storage-driver' => 'overlay2'
}

directory '/etc/systemd/system/docker.service.d'

file '/etc/docker/daemon.json' do
  content JSON.pretty_generate(dConf)
  notifies :restart, 'service[docker]'
end

service 'docker' do
  action [:enable, :start]
end
