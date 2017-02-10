require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    column_names = params.keys
    vals = column_names.map { |key| params[key] }
    where_line = column_names.map do |col|
      "#{col} = ?"
    end.join(' AND ')

    results = DBConnection.execute(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{where_line}
    SQL

    parse_all(results)
  end
end

class SQLObject
  # Mixin Searchable here...
  extend Searchable

end
