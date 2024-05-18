require 'net/http'
module StorageBackend
    class S3Compatible
        def initialize(config)
            @access_key_id = config[:access_key_id]
            @secret_access_key = config[:secret_access_key]
            @region = config[:region]
            @bucket = config[:bucket]
            @base_url = "https://#{@bucket}.s3.#{@region}.amazonaws.com"
        end

        def put_object(path, content)
            uri = URI.parse("#{@base_url}/#{path}")
            http_method = "PUT"
            canonical_uri = "/#{path}"

            content_sha256 = get_content_sha256(content)
            headers = generate_headers(content_sha256)
            datetime = headers[:"x-amz-date"]
            date = datetime[0,8]

            canonical_request = get_canonical_request(http_method, canonical_uri, headers, content_sha256)
            credential_scope = get_credential_scope(datetime)
            string_to_sign = get_string_to_sign(datetime, credential_scope, canonical_request)
            authorization_header = generate_authorization_header(credential_scope, headers, signature(date, string_to_sign))

            response = make_request(http_method, uri, content, headers, authorization_header)
            puts response.read_body
            return path
        end

        def get_object(path)
            uri = URI.parse("#{@base_url}/#{path}")
            http_method = "GET"
            canonical_uri = "/#{path}"

            content_sha256 = get_content_sha256(nil)
            headers = generate_headers(content_sha256)
            datetime = headers[:"x-amz-date"]
            date = datetime[0,8]

            canonical_request = get_canonical_request(http_method, canonical_uri, headers, content_sha256)
            credential_scope = get_credential_scope(datetime)
            string_to_sign = get_string_to_sign(datetime, credential_scope, canonical_request)
            authorization_header = generate_authorization_header(credential_scope, headers, signature(date, string_to_sign))

            response = make_request(http_method, uri, nil, headers, authorization_header)
            return response.body
        end

        private
        def get_content_sha256(content)
            if content
                return Digest::SHA256.hexdigest(content)
            else
                return Digest::SHA256.hexdigest('')
            end
        end

        def generate_headers(content_sha256)
            return {
                'host': "#{@bucket}.s3.#{@region}.amazonaws.com",
                'x-amz-date': Time.now.utc.strftime('%Y%m%dT%H%M%SZ'),
                'x-amz-content-sha256': content_sha256,
            }
        end

        def canonical_header_value(value)
            value.gsub(/\s+/, ' ').strip
        end

        def get_canonical_request(http_method, canonical_uri, headers, content_sha256)
            canonical_headers = headers.sort_by(&:first).map{|k,v| "#{k}:#{canonical_header_value(v.to_s)}" }.join("\n")
            signed_headers = headers.each_key.sort.join(";")
            return [
                http_method,
                canonical_uri,
                '',
                canonical_headers + "\n",
                signed_headers,
                content_sha256,
            ].join("\n")
        end

        def get_credential_scope(datetime)
            date = datetime[0,8]
            return [
                date,
                @region,
                "s3",
                'aws4_request',
            ].join('/')
        end

        def get_string_to_sign(datetime, credential_scope, canonical_request)
            return [
                'AWS4-HMAC-SHA256',
                datetime,
                credential_scope,
                sha256_hexdigest(canonical_request),
            ].join("\n")
        end

        def sha256_hexdigest(value)
            OpenSSL::Digest::SHA256.hexdigest(value)
        end

        def signature(date, string_to_sign)
            k_date = hmac("AWS4" + @secret_access_key, date)
            k_region = hmac(k_date, @region)
            k_service = hmac(k_region, "s3")
            k_credentials = hmac(k_service, 'aws4_request')
            hexhmac(k_credentials, string_to_sign)
        end

        def hmac(key, value)
            OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), key, value)
        end

        def hexhmac(key, value)
            OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), key, value)
        end

        def generate_authorization_header(credential_scope, headers, signature)
            signed_headers = headers.each_key.sort.join(";")
            return [
                "AWS4-HMAC-SHA256 Credential=#{"#{@access_key_id}/#{credential_scope}"}",
                "SignedHeaders=#{signed_headers}",
                "Signature=#{signature}",
            ].join(', ')
        end

        def make_request(http_method, uri, payload, headers, authorization_header)
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            request = Net::HTTP.const_get(http_method.capitalize).new(uri)
            request.body = payload
            headers.each { |key, value| request[key] = value }
            request['Authorization'] = authorization_header

            response = http.request(request)
            return response
        end

    end
end
