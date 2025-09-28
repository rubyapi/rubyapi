# frozen_string_literal: true

class ObjectsController < ApplicationController
  skip_forgery_protection only: [:toggle_signatures]

  rescue_from Elasticsearch::Persistence::Repository::DocumentNotFound,
    OpenSearch::Transport::Transport::Errors::NotFound,
    with: -> { raise ActionController::RoutingError.new("Not Found") }

  def show
    expires_in 24.hours, public: true, must_revalidate: true
    @object = object_repository.find(document_id)
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

  def object_repository
    @repository ||= RubyObjectRepository.repository_for_release(Current.ruby_release)
  end

  def document_id
    RubyObject.id_from_path(object)
  end

  def object
    params[:object].try(:downcase)
  end
end
