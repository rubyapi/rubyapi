# frozen_string_literal: true

class HealthcheckController < ApplicationController
  def index
    render plain: "pong"
  end
end
