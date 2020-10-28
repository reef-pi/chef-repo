apt_repository 'k8s' do
   uri 'https://apt.kubernetes.io'
   distribution 'kubernetes-xenial'
   components %w(main)
   arch 'amd64'
   key 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
end

package %w(kubelet kubeadm kubectl)
