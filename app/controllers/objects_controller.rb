# frozen_string_literal: true

class ObjectsController < ApplicationController
  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound, with: -> { raise ActionController::RoutingError.new("Not Found") }

  before_action :set_cache

  def show
    session[:show_signatures] ||= false
    @show_signatures = session[:show_signatures]
    @object = object_repository.find(document_id)
  end

  def toggle_signatures
    session[:show_signatures] = !ActiveRecord::Type::Boolean.new.cast(session[:show_signatures])
    redirect_back_or_to root_path
  end

  def not_found
    render plain: "Not found", status: :not_found
  end

  private

  def set_cache
    signatures_enabled? ? enable_private_cache : enable_public_cache
  end

  def signatures_enabled?
    !!session[:show_signatures]
  end

  def object_repository
    @repository ||= RubyObjectRepository.repository_for_version(ruby_version)
  end

  def document_id
    RubyObject.id_from_path(object)
  end

  def object
    params[:object].try(:downcase)
  end
end
