# -*- encoding : utf-8 -*-

namespace :db do
  desc "migrate"
  task :migrate => :environment do
    MongoidMigrations::Migrator.migrate("db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end

  desc "generate a new file"
  task :generate_migration_file, :name do |t, args|
    include ActiveSupport::Inflector
    file_name = "db/migrate/#{Time.now.strftime('%Y%m%d%H%M')}_#{args.name}.rb"
    print "creating #{file_name}"
    File.open(file_name, 'w') do |file|
      file.puts "# -*- encoding : utf-8 -*-"
      file.puts "class #{camelize(args.name)} < MongoidMigrations::Migration"
      file.puts "  def self.migrate(collections)"
      file.puts "  end"
      file.puts "end"
    end
  end
end
