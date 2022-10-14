# Overwrite existing javascript:build rake task
Rake::Task["css:build"].clear

namespace :css do
  task :build do
    unless system "npm i && npm run build:css"
      raise "Command build failed, ensure npm is installed and `npm run build:css` runs without errors"
    end
  end
end
