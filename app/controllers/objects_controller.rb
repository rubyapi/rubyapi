# frozen_string_literal: true

class ObjectsController < ApplicationController
  skip_forgery_protection only: [ :toggle_signatures ]

  def show
    expires_in 24.hours, public: true, must_revalidate: true

    @object = RubyObject.find_by!(path: object, ruby_version: Current.ruby_version)
    @superclass = RubyObject.find_by(path: @object.superclass, ruby_version: Current.ruby_version) if @object&.superclass.present?
    @included_modules = RubyObject.where(path: @object.included_modules, ruby_version: Current.ruby_version)
  end

  def toggle_signatures
    expires_in 0, public: false

    cookies.permanent[:signatures] = {
      value: !Current.enable_method_signatures,
      secure: Rails.env.production?,
      httponly: true
    }

    redirect_back_or_to root_path
  end

  private

  def not_found
    render plain: "Not found", status: :not_found
  end

  def object
    params[:object].try(:downcase)
  end
end
