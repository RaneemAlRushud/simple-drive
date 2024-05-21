class Storage
    def initialize()
        @storage_service = ENV["DEFAULT_STORAGE_BACKEND"]

        storage_config = Rails.application.credentials.config[:storage]
        @localstorage = StorageBackend::LocalStorage.new(storage_config[:local_storage])
        @s3_compatible = StorageBackend::S3Compatible.new(storage_config[:s3_compatible])
        @ftp_storage = StorageBackend::Ftp.new(storage_config[:ftp_storage])
        @db_storage = StorageBackend::DatabaseStorage.new(storage_config[:db_storage])
    end

    def store(id, content)
        if @storage_service == "local"
            file_path = @localstorage.write_to_file(id, content)
        elsif @storage_service == "s3_compatible"
            file_path = @s3_compatible.put_object(id, content)
        elsif @storage_service == "ftp"
            file_path = @ftp_storage.upload(content)
        elsif @storage_service == "db"
            table_name, id = @db_storage.insert_row(id, content)
            return {
                storage: @storage_service,
                "table": table_name,
                "id": id
            }
        end
        {
            storage: @storage_service,
            path: file_path
        }
    end

    def retrieve(metadata)
        if metadata["storage"] == "local"
            return @localstorage.read_from_file(metadata["path"])
        elsif metadata["storage"] == "s3_compatible"
            return @s3_compatible.get_object(metadata["path"])
        elsif metadata["storage"] == "ftp"
            return @ftp_storage.read_content(metadata["path"])
        elsif metadata["storage"] == "db"
            return @db_storage.read_row(metadata["table"], metadata["id"])
        else
            raise "invalid storage"
        end
    end
end