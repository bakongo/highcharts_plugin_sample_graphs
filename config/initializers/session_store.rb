# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_numbers_to_graph_session',
  :secret      => '4efb0072caa7f75ea0ad583805ff7e88cc94dcd007055cf9b5dbf0c8d2ec3c231c516a3af1c437ea10cc6296e721e1ea685fc69f0eab473626673db0345351bb'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
