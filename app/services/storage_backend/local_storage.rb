module StorageBackend
    class LocalStorage
        def initialize(config)
            @base_dir = config[:base_dir]
        end

        def write_to_file(id, content)
            file_path = "#{@base_dir}/#{id}"
            File.open(file_path, 'w') do |file|
                file.write(content)
            end
            file_path
        end

        def read_from_file(file_path)
            content = File.read(file_path)
            return content
        end
    end
end
