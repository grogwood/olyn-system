# Loop through each SSL cert item in the data bag
data_bag('ssl_certificates').each do |ssl_certificates_item_name|

  # Load the data bag item
  ssl_certificates_item = data_bag_item('ssl_certificates', ssl_certificates_item_name)

  # Loop through each file in the SSL data bag item
  ssl_certificates_item[:certificates].each do |_, cert|

    # Determine the directory path for the file
    directory = File.dirname(cert['file'])

    # Create the destination directory if it does not exist
    directory directory do
      recursive true
      action :create
    end

    # Create the certificate file
    template cert['file'] do
      source 'ssl_certificate.erb'
      variables(
        ssl_certificate: cert['content']
      )
      sensitive true
    end

  end
end
