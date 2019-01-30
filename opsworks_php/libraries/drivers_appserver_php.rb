# frozen_string_literal: true

module Drivers
  module Appserver
    class Php < Drivers::Appserver::Base
      adapter :php
      allowed_engines :php
      # output filter: %i[max_pool_size min_instances mount_point]
      output filter: %i[]

      def manual_action(action); end

      def add_appserver_config; end

      def add_appserver_service_script; end

      def add_appserver_service_context; end

      def webserver_config_params
        # o = out
        # Hash[%i[max_pool_size min_instances mount_point].map { |k| [k, o[k]] }].reject { |_k, v| v.nil? }
      end
    end
  end
end
