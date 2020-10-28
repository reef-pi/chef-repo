package %w(apt-transport-https ca-certificates curl software-properties-common gnupg2)

swap_file '/swapfile' do
  action :remove
end

%w(overlay br_netfilter).each do |m|
  kernel_module m
end

%w(net.ipv4.ip_forward
  net.bridge.bridge-nf-call-iptables
  net.bridge.bridge-nf-call-ip6tables).each do |k|
  sysctl k do
    value 1
  end
end
