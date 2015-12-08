require 'digest'

input = "yzbqklnj"
index = -1;
output = nil
while (output == nil || output.chars.take(5).count{|c|c=="0"} != 5)
index += 1
md5 = Digest::MD5.new
md5 << input
md5 << index.to_s
output = md5.hexdigest
if (index % 10 == 0)
puts index
end
end
puts output
puts index
