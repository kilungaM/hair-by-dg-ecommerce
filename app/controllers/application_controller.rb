  class ApplicationController < ActionController::Base
  include BreadcrumbsHelper  # Add this line
  add_flash_types :success, :error, :warning, :info
end