# -*- encoding : utf-8 -*-
module MongoidMigrations
  class MigrationFiles
    def initialize(path)
      @path = path
    end

    def list
      files = Dir["#{@path}/[0-9]*_*.rb"]

      migrations = files.inject([]) do |klasses, file|
        version, name = file.scan(/([0-9]+)_([_a-z0-9]*).rb/).first
        raise IllegalMigrationNameError.new(file) unless version
        version = version.to_i

        if klasses.detect { |m| m.version == version }
          raise DuplicateMigrationVersionError.new(version)
        end

        if klasses.detect { |m| m.name == name.camelize }
          raise DuplicateMigrationNameError.new(name.camelize)
        end

        migration = MigrationProxy.new
        migration.name     = name.camelize
        migration.version  = version
        migration.filename = file
        klasses << migration
      end

      migrations = migrations.sort_by(&:version)
     end
  end
end
