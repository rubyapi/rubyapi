module ApplicationHelper
  def homepage?
    current_page?(root_path) || current_page?(versioned_root_path(version: ruby_version))
  end
end
