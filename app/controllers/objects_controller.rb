# frozen_string_literal: true

class ObjectsController < ApplicationController
  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound, with: -> { raise ActionController::RoutingError.new("Not Found") }

  before_action :enable_public_cache, only: [:show]

  def show
    @show_signatures = ActiveModel::Type::Boolean.new.cast(cookies[:signatures]) || request.env["HTTP_FASTLY_SIGNATURES"].present?
    @object = object_repository.find(document_id)
  end

  def toggle_signatures
    cookies.permanent[:signatures] = !ActiveModel::Type::Boolean.new.cast(cookies[:signatures])

    redirect_back_or_to root_path
  end

  private

  def not_found
    render plain: "Not found", status: :not_found
  end

  def object_repository
    @repository ||= RubyObjectRepository.repository_for_version(Current.ruby_version)
  end

  def document_id
    RubyObject.id_from_path(object)
  end

  def object
    params[:object].try(:downcase)
  end
end
