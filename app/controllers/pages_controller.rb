# frozen_string_literal: true

class PagesController < ApplicationController
  def show
    expires_in 24.hours, public: true, must_revalidate: true
    @page = RubyPage.find_by!(path: params[:page]&.downcase, documentable: Current.ruby_release)
  end
end
