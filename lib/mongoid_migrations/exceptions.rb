# -*- encoding : utf-8 -*-
module MongoidMigrations
  class DuplicateMigrationVersionError < RuntimeError
    def initialize(version)
      super("Multiple migrations have the version number #{version}")
    end
  end

  class DuplicateMigrationNameError < RuntimeError
    def initialize(name)
      super("Multiple migrations have the name #{name}")
    end
  end

  class UnknownMigrationVersionError < RuntimeError
    def initialize(version)
      super("No migration with version number #{version}")
    end
  end

  class IllegalMigrationNameError < RuntimeError
    def initialize(name)
      super("Illegal name for migration file: #{name}\n\t(only lower case letters, numbers, and '_' allowed)")
    end
  end
end
