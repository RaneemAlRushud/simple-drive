module StorageBackend
    class DatabaseStorage
        def initialize(config)
            @db_host = config[:host]
            @db_name = config[:name]
            @table_name = config[:table]
            create_db_if_not_exists
            create_table_if_not_exists
        end

        def read_row(table, id)
            conn = get_pg_connection

            select_query = "SELECT data FROM #{table} WHERE id = '#{id}' LIMIT 1;"
            # Execute the query and store the result
            result = conn.exec(select_query)

            raise "No row found" if result.values.size == 0
            return result.values[0][0]
        end

        def insert_row(id, data)
            conn = get_pg_connection
            
            insert_query = "INSERT INTO #{@table_name} (id, data) VALUES ($1, $2);"
            values = [id, data]
            conn.exec_params(insert_query, values)
            
            conn.close
            return [@table_name, id]
        end

        private
        def get_pg_connection
            PG.connect("postgresql://localhost:5432/simple_drive_db_storage")
        end

        def create_db_if_not_exists
            conn = PG.connect("postgresql://localhost:5432/simple_drive_db_storage")
            query = "SELECT FROM pg_database WHERE datname = '#{@db_name}'"
            result = conn.exec(query)
            if result.ntuples == 1
                return
            else
                create_database_query = "CREATE DATABASE IF NOT EXISTS #{@db_name}"
                result = conn.exec(query)
            end
            conn.close
        end

        def create_table_if_not_exists
            conn = get_pg_connection
            create_table_query = "CREATE TABLE IF NOT EXISTS #{@table_name} (id VARCHAR(255) PRIMARY KEY, data TEXT); CREATE INDEX IF NOT EXISTS idx_identifier ON #{@table_name} (id);"
            result = conn.exec(create_table_query)
            conn.close
        end
    end
end