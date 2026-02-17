module PathCleaner
  def self.clean(uri, constant:, version:)
    class_parts = constant.split("::")[0..-2]

    uri.path.delete_suffix(".html").split("/").each do |path_part|
      if path_part == ".."
        class_parts.pop
      elsif !class_parts.include?(path_part)
        class_parts.push(path_part)
      end
    end

    Rails.application.routes.url_helpers.object_path({
      version:,
      object: class_parts.join("/").downcase,
      anchor: uri.fragment
    })
  end
end
