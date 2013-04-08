# -*- encoding : utf-8 -*-
module MongoidMigrations
  class Migration
    class << self

      def process
        announce "migrating"

        result = nil
        time = Benchmark.measure do
          session = ::Mongoid.default_session
          session.with(safe: true) do |collections|
            result = migrate(collections)
          end
        end
        announce "migrated (%.4fs)" % time.real; write
        result
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
