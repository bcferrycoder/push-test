require 'net/http/post/multipart'

auth = 'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjbG91ZF9jb250cm9sbGVyIiwiaWF0IjoxNDIwNDgyODc0LCJleHAiOjE0MjA1NjkyNzQsImNsaWVudF9pZCI6ImNmIiwic2NvcGUiOlsib3BlbmlkIiwicGFzc3dvcmQud3JpdGUiLCJjbG91ZF9jb250cm9sbGVyLmFkbWluIiwiY2xvdWRfY29udHJvbGxlci5yZWFkIiwiY2xvdWRfY29udHJvbGxlci53cml0ZSIsInNjaW0ucmVhZCIsInNjaW0ud3JpdGUiXSwianRpIjoiZDdjNmIwNTgtYTM2YS00ZjRlLTkzM2YtNmQxYmViNmQ1YzJlIiwidXNlcl9pZCI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInN1YiI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInVzZXJfbmFtZSI6ImpkdyIsImVtYWlsIjoiamR3QGpkdy5jb20ifQ.wznwqcrbmr0ecjxG9Pc1jcuO3QnoWzjInyPCQOCeJcY'

## /info, no auth
uri = URI('https://api.192.168.0.112.xip.io/info')
req = Net::HTTP::Get.new(uri.path)
res = Net::HTTP.start(
        uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
  https.request(req)
end
puts res.body

##  /v2/organizations with auth
uri = URI('https://api.192.168.0.112.xip.io/v2/organizations')
req = Net::HTTP::Get.new uri.path,
  "Authorization" => "#{auth}"

res = Net::HTTP.start(
        uri.host, uri.port, 
        :use_ssl => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
  https.request(req)
end
puts res.body

## /app/GUID/bits
uri = URI('https://api.192.168.0.112.xip.io/v2/apps/2713d496-9a6e-4513-b081-3b3a358853ee/bits')
File.open("./application.zip") do |appzip|
   puts "upload"
   req = Net::HTTP::Put::Multipart.new uri.path,
  "Authorization" => "#{auth}",
  "name" => "node-chat",
  "resources" => "[]",
  "filename" => appzip
  res = Net::HTTP.start(uri.host, uri.port,
        :use_ssl => uri.scheme == 'https', 
        :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
    https.request(req)
  end
end
puts res.body

exit

## THIS WORKS FOR UPLOAD SERVER
puts "uploading to #{url}"
File.open("./upload.txt") do |jpg|
  puts "upload"
  req = Net::HTTP::Post::Multipart.new url.path,
  "myfile" => UploadIO.new(jpg, "text/plain", "upload.txt"),
  "Authorization" => "#{auth}",
  "name" => "node-chat",
  "resources" => "[]"
  res = Net::HTTP.start(url.host, url.port) do |http|
    http.request(req)
  end
end
