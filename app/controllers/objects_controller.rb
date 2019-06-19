class ObjectsController < ApplicationController
  def show
    @object = RubyObject.find_by! path: object, version: ruby_version
  end

  private

  def object
    params[:object].try(:downcase)
  end
end
