# -*- encoding : utf-8 -*-
module MongoidMigrations
  class Migration
    class << self

      def process
        announce "migrating"

        result = nil

        @migration_task_status = []
        time = Benchmark.measure do
          session = ::Mongoid.default_session
          session.with(safe: true) do |collections|
            run_migration_tasks(collections)
          end
        end
        announce "migrated (%.4fs)" % time.real; write
        result
      end

      def run_migration_tasks(collections)
        begin
          #Migration
          migration_tasks.each do |migration|
            announce "running migration #{migration}"
            @migration_task_status << migration
            self.send(migration,collections)
          end
        rescue Exception => ex
          #Rollback
          @migration_task_status.each do |migration|
            announce "rollback migration #{migration}"
            self.send("rollback_#{migration[:task]}".to_sym, collections)
          end
          announce ex
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
