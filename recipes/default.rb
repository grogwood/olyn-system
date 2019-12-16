# Install all required packages
include_recipe 'olyn_system::hosts'

# Install all required packages
include_recipe 'olyn_system::packages'

# Install SSL certificates
include_recipe 'olyn_system::ssl_certificates'

# Set the timezone
include_recipe 'olyn_system::timezone'

# Add system users and SSH keys
include_recipe 'olyn_system::users'