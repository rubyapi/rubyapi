# frozen_string_literal: true

class ObjectsController < ApplicationController
  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound, with: :not_found

  before_action :enable_public_cache

  caches_action :show,
    expires_in: 30.minutes,
    # Setting the cache path, because I had troubles getting the separate Ruby versions to
    # have their own caches. Calling `url_for` for /2.7/o/string simply returns /o/string, and
    # `url_for` is the default cache path.
    cache_path: -> { "/#{params[:version]}/o/#{params[:object]}" }

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
