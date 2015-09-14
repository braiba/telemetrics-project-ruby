module Floow
#
# Helper class for batching inserts to a single table
#
class SqlInsertBatcher
  MAX_BATCH_SIZE = 500 # The adapter complains if we batch more than 500

  def initialize(table_name, column_names)
    @table_name     = table_name
    @column_names   = column_names
    @sql_inserts    = []
  end

  def push(row_data)
    @sql_inserts.push '(' + row_data.join(', ') + ')'

    if @sql_inserts.length == MAX_BATCH_SIZE
      flush
    end
  end


  def flush
    unless @sql_inserts.empty?
      logger = ActiveRecord::Base.logger

      # Temporarily disable logging of the sql, because this statement will be extremely long and outputting it to
      #  the console would take ages
      prev_log_level = logger.level
      logger.level   = Logger::INFO

      sql = 'INSERT INTO journey_data (' + @column_names.join(', ') + ') VALUES ' + @sql_inserts.join(', ') + ';'
      ActiveRecord::Base.connection.execute sql

      logger.level = prev_log_level

      @sql_inserts = []
    end
  end
end
end
