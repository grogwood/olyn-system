# Loop through each packages item in the data bag
data_bag('packages').each do |package_item|

  # Load the data bag item
  package_set = data_bag_item('packages', package_item)

  # Skip package sets that are not auto install enabled
  next unless package_set[:auto_install]

  # Install all PHP packages in the data bag
  package_set[:packages].each do |package|
    package package do
      action :install
    end
  end
end
