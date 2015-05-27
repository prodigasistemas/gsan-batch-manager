desc "Generate spec coverage report"
namespace :test do
  task :coverage do
    ENV["COVERAGE"] = "true"
    Rake::Task["test"].invoke
  end
end
