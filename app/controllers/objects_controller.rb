# frozen_string_literal: true

class ObjectsController < ApplicationController
  skip_forgery_protection only: [:toggle_signatures]

  def show
    expires_in 24.hours, public: true, must_revalidate: true
    @object = RubyObject.find_by!(path: params[:object]&.downcase, documentable: Current.ruby_release)
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
end
