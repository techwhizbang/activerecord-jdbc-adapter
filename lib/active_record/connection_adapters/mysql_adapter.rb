tried_gem = false
begin
  require "jdbc/mysql"
rescue LoadError
  unless tried_gem
    require 'rubygems'
    gem "jdbc-mysql"
    tried_gem = true
    retry
  end
  # trust that the mysql jar is already present
end
require 'active_record/connection_adapters/jdbc_adapter'

module ActiveRecord
  module ConnectionAdapters
    class JdbcAdapter < AbstractAdapter

      # Returns a table's primary key and belonging sequence.
      def pk_and_sequence_for(table)
        keys = nil
        java_jdbc_result_set = @connection.connection.get_meta_data.get_primary_keys(nil, nil, table)
        has_first = java_jdbc_result_set.first
        if has_first
          java_jdbc_result_set.first
          keys = [java_jdbc_result_set.getString("COLUMN_NAME"), nil]
        end

        keys.blank? ? nil : keys
      end
    end
  end
end
