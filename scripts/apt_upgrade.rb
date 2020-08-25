require 'chef'
require 'net/ssh'
require 'highline/import'

Chef::Config.from_file('.chef/config.rb')
q = Chef::Search::Query.new(Chef::Config[:chef_server_url])
pass = ask('Password:'){ |q| q.echo = false }
q.search(:node, 'name:*', filter_result:{ name: %w(name), ip_address: %w(ipaddress)}) do |n|
  Net::SSH.start(n['ip_address'], 'pi', password: pass) do |ssh|
    puts "****************** Upgrading: #{n['name']} *************"
    ssh.exec!("sudo apt-get dist-upgrade -y") do |ch,st,data|
      data.display
    end
  end
end
