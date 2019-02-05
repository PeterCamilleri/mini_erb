require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

desc "What version of mini_erb is this?"
task :vers do |t|
  puts
  puts "mini_erb version = #{::MiniErb::VERSION}"
end
