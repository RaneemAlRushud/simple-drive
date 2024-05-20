module StorageBackend
    class Ftp
        def initialize(config)
            @host = config[:host]
            @user = config[:user]
            @password = config.include?(:password) ? config[:password] : ""
            @remote_dir = config.include?(:remote_dir) ? config[:remote_dir] : ""
        end

        def upload(content)
            local_file_path = write_to_tmp_file(content)

            remote_file_path = "#{@remote_dir}/#{random_filename}"
            ftp_client = get_ftp_client
            ftp_client.put(local_file_path, remote_file_path)
            ftp_client.close
        
            remove_tmp_file(local_file_path)
            return remote_file_path
        end

        def read_content(remote_file_path)
            local_file_path = "/tmp/#{random_filename}"
            
            ftp_client = get_ftp_client
            ftp_client.get(remote_file_path, local_file_path)

            content = File.read(local_file_path)

            remove_tmp_file(local_file_path)
            return content
        end

        private
        def get_ftp_client
            ftp_client = Net::FTP.new(@host, {debug_mode: true, passive: false})
            ftp_client.login(@user, @password)
            ftp_client
        end

        def write_to_tmp_file(content)
            local_file_path = "/tmp/#{random_filename}"
            File.open(local_file_path, 'w') do |file|
                file.write(content)
            end
            local_file_path
        end

        def remove_tmp_file(file_path)
            begin
                File.open(file_path, 'r') do |f|
                  File.delete(f)
                end
            rescue Errno::ENOENT
            end
        end

        def random_filename
            require 'securerandom'
            SecureRandom.alphanumeric(20)
        end
    end
end
