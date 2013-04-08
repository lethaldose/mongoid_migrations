# -*- encoding : utf-8 -*-
module MongoidMigrations
  class Migrator
    class << self
      def migrate(migrations_path, target_version = nil)
        self.new(migrations_path, target_version).migrate
      end

      def get_all_versions
        DataMigration.all_versions
      end

      def current_version
        get_all_versions.max || 0
      end
    end

    def initialize(migrations_path, target_version = nil)
      @migrations_path, @target_version = migrations_path, target_version
    end

    def current_version
      migrated.last || 0
    end

    def current_migration
      migrations.detect { |m| m.version == current_version }
    end

    def migrate
      current = migrations.detect { |m| m.version == current_version }
      target = migrations.detect { |m| m.version == @target_version }

      if target.nil? && !@target_version.nil? && @target_version > 0
        raise UnknownMigrationVersionError.new(@target_version)
      end

      finish = migrations.index(target) || migrations.size - 1
      runnable = migrations[0..finish]
      runnable.each do |migration|
        puts "Migrating to #{migration.name} (#{migration.version})"

        next if migrated.include?(migration.version.to_i) or migration.skip?

        begin
          migration.process
          record_version_state_after_migrating(migration.version)
        rescue => e
          raise StandardError, "An error has occurred, #{migration.version} and all later migrations canceled:\n\n#{e}", e.backtrace
        end
      end
    end

    def migrations
      @migrations ||= MigrationFiles.new(@migrations_path).list
    end

    def pending_migrations
      already_migrated = migrated
      migrations.reject { |m| already_migrated.include?(m.version.to_i) }
    end

    def migrated
      @migrated_versions ||= self.class.get_all_versions
    end

    private
      def record_version_state_after_migrating(version)
        @migrated_versions ||= []
        @migrated_versions.push(version).sort!
        DataMigration.create(:version => version.to_s)
      end
  end
end
