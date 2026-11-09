module PathCleaner
  def self.clean(uri, constant:, version:, page_paths: {})
    class_parts = constant.gsub("::", "/").split("/")[0...-1]

    uri.path.split("/").each do |path_part|
      next if path_part == "."

      if path_part == ".."
        class_parts.pop
      else
        class_parts.push(path_part)
      end
    end

    path = class_parts.join("/")
    anchor = uri.fragment

    if page = page_paths[path]
      Rails.application.routes.url_helpers
        .page_path(
          version:,
          page:,
          anchor:
        )
    else
      object = path.delete_suffix(".html").downcase
      Rails.application.routes.url_helpers
        .object_path(
          version:,
          object:,
          anchor:
        )
    end
  end
end
