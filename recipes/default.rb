# Include the Litespeed repo recipe
include_recipe 'olyn_litespeed::repo'

# Include the main Litespeed installer recipe
include_recipe 'olyn_litespeed::install'

# Install PHP
include_recipe 'olyn_litespeed::php'

# Configure vhosts
include_recipe 'olyn_litespeed::vhosts'
