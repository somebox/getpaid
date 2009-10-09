# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/switchtower.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

namespace :db do
  namespace :test do
    desc "Loads database models into test db."
    task :populate => "db:test:prepare" do
      RAILS_ENV = 'test'
      Rake::Task["db:fixtures:load"].invoke
    end
  end
  namespace :dev do
    desc "Loads database models into dev db."
    task :populate => "db:test:prepare" do
      Rake::Task["db:fixtures:load"].invoke
    end
    
    desc "Refresh from production db"
    task :refresh do
      system('mysqladmin drop somebox_billing_dev')
      system('mysqladmin create somebox_billing_dev')
      system('mysqldump --opt somebox_billing_production | mysql somebox_billing_dev')
    end
  end
end

namespace :db do
  namespace :fixtures do
    task :validate => :environment do
      name_map = Hash.new { |h,k| h[k] = k }

      Dir.chdir("app/models") do
        map = `grep set_table_name *.rb`.gsub(/[:\'\"]+|set_table_name/, '').split
        Hash[*map].each do |file, name|
          name_map[name] = file.sub(/\.rb$/, '')
        end
      end

      Dir["test/fixtures/*.yml"].each do |fixture|
        fixture = name_map[File.basename(fixture, ".yml")]

        begin
          klass = fixture.classify.constantize
          klass.find(:all).each do |thing|
            unless thing.valid? then
              puts "#{fixture}: id ##{thing.id} is invalid:" 
              thing.errors.full_messages.each do |msg|
                puts "  - #{msg}" 
              end
              puts 
            end
          end
        rescue => e
          puts "#{fixture}: skipping: #{e.message}" 
        end
      end
    end # validate
  end # fixtures
end # db

