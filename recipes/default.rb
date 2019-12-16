# Include the main litespeed recipe
include_recipe 'olyn_litespeed::litespeed'

# Install PHP
include_recipe 'olyn_litespeed::php'

# Configure vhosts
include_recipe 'olyn_litespeed::vhosts'