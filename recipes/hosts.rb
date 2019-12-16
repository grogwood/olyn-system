# Configure the hosts file
template '/etc/hosts' do
  source 'hosts.erb'
  mode 0644
  owner 'root'
  group 'root'
  variables(
    local_server:    data_bag_item('servers', node[:hostname]),
    server_data_bag: data_bag('servers')
  )
end