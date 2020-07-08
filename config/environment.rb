# frozen_string_literal: true

# Set up the default faraday adapter:
require 'async/http/faraday/default'

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!
