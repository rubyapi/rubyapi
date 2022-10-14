# Overwrite existing javascript:build rake task
Rake::Task["css:build"].clear

namespace :javascript do
  task :css do
    unless system "npm i && npm run build"
      raise "Command build failed, ensure npm is installed and `npm run build:css` runs without errors"
    end
  end
end
