class ObjectsController < ApplicationController
  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound, with: :not_found

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
