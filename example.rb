require './lib-liff/liff_api'
liff = LIFF.new("your_channel_access_token")
puts liff.update_liff("view type", "https://example.com")
puts liff.delete_liff("your_liffId")