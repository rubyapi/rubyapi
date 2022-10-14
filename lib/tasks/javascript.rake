# Overwrite existing javascript:build rake task
Rake::Task["javascript:build"].clear

namespace :javascript do
  task :build do
    unless system "npm i && npm run build"
       raise "Command build failed, ensure npm is installed and `npm run build` runs without errors"
    end
  end
end
