class ObjectsController < ApplicationController
  def show
    @object = object_repository.find(document_id)
  end

  private

  def object_repository
    @repository ||= RubyObjectRepository.repository_for_version(ruby_version)
  end

  def document_id
    Base64.encode64(object)
  end

  def object
    params[:object].try(:downcase)
  end
end
