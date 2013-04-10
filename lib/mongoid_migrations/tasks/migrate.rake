# -*- encoding : utf-8 -*-

namespace :db do
  desc "migrate"
  task :migrate => :environment do
    MongoidMigrations::Migrator.migrate("db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc "generate a new file"
  task :generate_migration_file, :name do |t, args|
    include ActiveSupport::Inflector
    unless Dir.exists? "db/migrate"
      Dir.mkdir("db/migrate")
      puts "Created migration scripts directory: #{File.expand_path('db/migrate')}"
    end

    file_name = "db/migrate/#{Time.now.strftime('%Y%m%d%H%M')}_#{args.name}.rb"
    print "creating #{file_name}"
    File.open(file_name, 'w') do |file|
      class_name=camelize(args.name)
      template = ERB.new(File.read(File.join(File.dirname(__FILE__), 'migration_template.erb')))
      file.puts template.result(binding)
    end
  end
end
