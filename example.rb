require './lib-liff/app'
liff = LINEFrontEndFramework.new("your_channel_access_token")
puts liff.add_liff("full", "https://example.com")
puts liff.delete_liff("liffId")