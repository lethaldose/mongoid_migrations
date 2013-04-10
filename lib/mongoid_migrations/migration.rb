# -*- encoding : utf-8 -*-
module MongoidMigrations
  class Migration
    class << self

      def session_for database
        announce "creating session for #{database}"
        session = Mongoid::Sessions::Factory.create(database)
        session.with(safe: true) do |collections|
          yield collections
        end
      end

      def process
        announce "migrating"

        result = nil
        @migration_task_status = []

        time = Benchmark.measure do
          run_migration_tasks
        end
        announce "migrated (%.4fs)" % time.real; write
        result
      end

      def run_migration_tasks
        begin
          #Migration
          migration_tasks.each do |migration|
            announce "running migration #{migration}"
            @migration_task_status << migration
            self.send(migration)
          end
        rescue Exception => ex
          #Rollback
          announce ex
          announce ex.backtrace
          @migration_task_status.each do |migration|
            announce "rollback migration #{migration}"
            self.send("rollback_#{migration}".to_sym)
          end
          raise ex
        end
      end

      def write(text="")
        puts(text)
      end

      def skip?
        respond_to?(:toggled?) and not toggled?
      end

      def announce(message)
        version = defined?(@version) ? @version : nil
        text = "#{version} #{name}: #{message}"
        length = [0, 75 - text.length].max
        write "== %s %s" % [text, "=" * length]
      end

    end
  end
end
