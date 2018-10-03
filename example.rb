require './lib-liff/liff_api'
liff = LIFF.new("your_channel_access_token")
puts liff.add_liff("full", "https://example.com")
puts liff.delete_liff("liffId")