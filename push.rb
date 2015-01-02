require 'net/http/post/multipart'

auth = 'bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJjbG91ZF9jb250cm9sbGVyIiwiaWF0IjoxNDIwMjI2MTQ1LCJleHAiOjE0MjAzMTI1NDUsImNsaWVudF9pZCI6ImNmIiwic2NvcGUiOlsib3BlbmlkIiwicGFzc3dvcmQud3JpdGUiLCJjbG91ZF9jb250cm9sbGVyLmFkbWluIiwiY2xvdWRfY29udHJvbGxlci5yZWFkIiwiY2xvdWRfY29udHJvbGxlci53cml0ZSIsInNjaW0ucmVhZCIsInNjaW0ud3JpdGUiXSwianRpIjoiMmFlM2M4MDItYjUzNC00NzRjLWFlZDctZTIyYzkyZjM3MGJkIiwidXNlcl9pZCI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInN1YiI6IjFiMzYzMjNhLWYzMWEtNGMxMi1hYWRjLTA0Y2EzZDRkZGMwMCIsInVzZXJfbmFtZSI6ImpkdyIsImVtYWlsIjoiamR3QGpkdy5jb20ifQ._zalxJNwnFnk8hVNTFN5Osupq4a2gZhntkvZIgXBV7M'
#url = URI.parse('http://localhost:4567/upload')
url = URI.parse('https://api.stackato-p2cf.local/upload')


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
