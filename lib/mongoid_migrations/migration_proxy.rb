# -*- encoding : utf-8 -*-
module MongoidMigrations
  class MigrationProxy
    attr_accessor :name, :version, :filename
    extend Forwardable

    def_delegators :migration, :process, :announce, :write, :skip?

    private

      def migration
        @migration ||= load_migration
      end

      def load_migration
        require(File.expand_path(filename))
        name.constantize
      end
  end
end
