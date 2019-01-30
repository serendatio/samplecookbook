# frozen_string_literal: true

module Drivers
  module Framework
    class Phinx < Drivers::Framework::Base
      adapter :phinx
      allowed_engines :phinx
      output filter: %i[
        migrate migration_command
      ]
    end
  end
end
