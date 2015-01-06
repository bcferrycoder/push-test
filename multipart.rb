# This is from:  http://stackoverflow.com/questions/184178/ruby-how-to-post-a-file-via-http-as-multipart-form-data
# Also see this cheat sheet: http://www.rubyinside.com/nethttp-cheat-sheet-2940.html

# Takes a hash of string and file parameters and returns a string of text
# formatted to be sent as a multipart form post.
#
# Author:: Cody Brimhall <mailto:brimhall@somuchwit.com>
# Created:: 22 Feb 2008
# License:: Distributed under the terms of the WTFPL (http://www.wtfpl.net/txt/copying/)

require 'net/http'
require 'mime/types'
require 'rubygems'
require 'cgi'
require 'uri'

module Multipart
  VERSION = "1.0.0"

  # Formats a given hash as a multipart form post
  # If a hash value responds to :string or :read messages, then it is
  # interpreted as a file and processed accordingly; otherwise, it is assumed
  # to be a string
  class Post
    # We have to pretend we're a web browser...
    USERAGENT = "Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-us) AppleWebKit/523.10.6 (KHTML, like Gecko) Version/3.0.4 Safari/523.10.6"
    BOUNDARY = "0123456789ABLEWASIEREISAWELBA9876543210"
    CONTENT_TYPE = "multipart/form-data; boundary=#{ BOUNDARY }"
    HEADER = { "Content-Type" => CONTENT_TYPE, "User-Agent" => USERAGENT }

    def self.prepare_query(params)
      fp = []

      params.each do |k, v|
        # Are we trying to make a file parameter?
        if v.respond_to?(:path) and v.respond_to?(:read) then
          fp.push(FileParam.new(k, v.path, v.read))
        # We must be trying to make a regular parameter
        else
          fp.push(StringParam.new(k, v))
        end
      end

      # Assemble the request body using the special multipart format
      query = fp.collect {|p| "--" + BOUNDARY + "\r\n" + p.to_multipart }.join("") + "--" + BOUNDARY + "--"
      return query, HEADER
    end
  end

  private

  # Formats a basic string key/value pair for inclusion with a multipart post
  class StringParam
    attr_accessor :k, :v

    def initialize(k, v)
      @k = k
      @v = v
    end

    def to_multipart
      return "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"\r\n\r\n#{v}\r\n"
    end
  end

  # Formats the contents of a file or string for inclusion with a multipart
  # form post
  class FileParam
    attr_accessor :k, :filename, :content

    def initialize(k, filename, content)
      @k = k
      @filename = filename
      @content = content
    end

    def to_multipart
      # If we can tell the possible mime-type from the filename, use the
      # first in the list; otherwise, use "application/octet-stream"
      mime_type = MIME::Types.type_for(filename)[0] || MIME::Types["application/octet-stream"][0]
      return "Content-Disposition: form-data; name=\"#{CGI::escape(k)}\"; filename=\"#{ filename }\"\r\n" +
             "Content-Type: #{ mime_type.simplified }\r\n\r\n#{ content }\r\n"
    end
  end
end


my_string = "somestring"
my_file = File.open("./application.zip")
data, headers = Multipart::Post.prepare_query("title" => my_string, "document" => my_file)

auth = 'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjbG91ZF9jb250cm9sbGVyIiwiaWF0IjoxNDIwNDgyODc0LCJleHAiOjE0MjA1NjkyNzQsImNsaWVudF9pZCI6ImNmIiwic2NvcGUiOlsib3BlbmlkIiwicGFzc3dvcmQud3JpdGUiLCJjbG91ZF9jb250cm9sbGVyLmFkbWluIiwiY2xvdWRfY29udHJvbGxlci5yZWFkIiwiY2xvdWRfY29udHJvbGxlci53cml0ZSIsInNjaW0ucmVhZCIsInNjaW0ud3JpdGUiXSwianRpIjoiZDdjNmIwNTgtYTM2YS00ZjRlLTkzM2YtNmQxYmViNmQ1YzJlIiwidXNlcl9pZCI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInN1YiI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInVzZXJfbmFtZSI6ImpkdyIsImVtYWlsIjoiamR3QGpkdy5jb20ifQ.wznwqcrbmr0ecjxG9Pc1jcuO3QnoWzjInyPCQOCeJcY'

#headers["Authorization"] = "#{auth}"

#headers["name"] = "node-chat"
#headers["resources"] = "[]"

puts "HEADERS: #{headers.inspect}"

upload_uri = URI('https://api.192.168.0.112.xip.io/v2/apps/2713d496-9a6e-4513-b081-3b3a358853ee/bits')

puts "UPLOAD_URI.PATH: #{upload_uri.path}"
puts "UPLOAD_URI.HOST: #{upload_uri.host}"
puts "UPLOAD_URI.PORT: #{upload_uri.port}"
puts "UPLOAD_URI.SCHEME: #{upload_uri.scheme}"
puts UPLOAD_URI: #{upload_url.inspect}"

http = Net::HTTP.new(upload_uri.host, upload_uri.port)
#        :use_ssl => upload_uri.scheme == 'https', 
#        :verify_mode => OpenSSL::SSL::VERIFY_NONE)

puts "DATASIZE: #{data.size.inspect}"
puts "DATA IS STRING #{data.is_a? String}"
puts "HEADERS IS STRING #{headers.is_a? String}"
puts "UPLOAD_URI.PATH IS STRING #{upload_uri.path.is_a? String}"

res = http.start( :use_ssl => upload_uri.scheme == 'https') {|con| con.post(upload_uri.path, data, headers) }
