# Loop through each user item in the data bag
data_bag('system_users').each do |user_item|

  # Load the data bag item
  user = data_bag_item('system_users', user_item)

  # Create the user's primary group
  group user[:groups]['primary'] do
    action :create
    append true
  end

  # Create the user account
  user user[:username] do
    password user[:password]
    gid user[:groups]['primary']
    home "/home/#{user[:username]}"
    manage_home true
    shell '/bin/bash'
    action :create
  end

  # Add the user into any secondary groups
  user[:groups]['secondary'].each do |group|
    group group do
      action :create
      members user[:username]
      append true
    end
  end

  # Move to the next user if SSH is disabled
  next unless user[:options]['ssh']['enabled']

  # Create the user's SSH folder
  directory "/home/#{user[:username]}/.ssh" do
    mode 0700
    owner user[:username]
    group user[:groups]['primary']
    action :create
  end

  # Loop through each SSH key component for this user
  user[:options]['ssh']['keys'].each do |_, ssh_key|

    # Create the key file
    template "/home/#{user[:username]}/.ssh/#{ssh_key['file']}" do
      source 'ssh_key.erb'
      mode 0600
      owner user[:username]
      group user[:groups]['primary']
      variables(
        ssh_key: ssh_key['key']
      )
      sensitive true
    end
  end

  # Set the user wrapper key ID
  wrapper_id = user[:options]['ssh']['wrapper']['key']

  # SSH wrapper
  template "/home/#{user[:username]}/.ssh/ssh_wrapper.sh" do
    source 'ssh_wrapper.sh.erb'
    mode 0744
    owner user[:username]
    group user[:groups]['primary']
    variables(
      username: user[:username],
      key_file: user[:options]['ssh']['keys'][wrapper_id]['file']
    )
    only_if { user[:options]['ssh']['wrapper']['enabled'] }
  end
end
