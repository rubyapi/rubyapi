class HomeController < ApplicationController
  def index
    expires_in 30.minutes, public: true
  end
end
