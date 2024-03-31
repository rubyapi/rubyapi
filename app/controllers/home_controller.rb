# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :enable_public_cache

  skip_forgery_protection only: [:set_theme]

  def set_theme
    theme = ThemeConfig.theme_for(params[:theme])

    if theme.blank?
      return head :bad_request
    end

    cookies[:theme] = theme.name

    redirect_back_or_to root_path
  end

  def index
    @tiles = [
      {
        class_name: "String",
        object_path: "string",
        description: "A String object holds and manipulates an arbitrary sequence of bytes, typically representing characters."
      },
      {
        class_name: "Integer",
        object_path: "integer",
        description: "Represent whole numbers in Ruby"
      },
      {
        class_name: "Array",
        object_path: "array",
        description: "Arrays are ordered, integer-indexed collections of any object."
      },
      {
        class_name: "Hash",
        object_path: "hash",
        description: "A Hash is a dictionary-like collection of unique keys and their values."
      },
      {
        class_name: "Symbol",
        object_path: "symbol",
        description: "Symbol objects represent names and some strings inside the Ruby interpreter."
      },
      {
        class_name: "Kernel",
        object_path: "kernel",
        description: "The Kernel module is included by class Object, so its methods are available in every Ruby object."
      }
    ]
  end
end
