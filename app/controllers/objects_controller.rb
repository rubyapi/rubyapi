# frozen_string_literal: true

class ObjectsController < ApplicationController
  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound, with: -> { raise ActionController::RoutingError.new("Not Found") }

  before_action :enable_public_cache

  def show
    @object = object_repository.find(document_id)
  end

  def not_found
    render plain: "Not found", status: :not_found
  end

  private

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
