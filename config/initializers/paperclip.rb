Rails.application.configure do
  config.paperclip_defaults = {
    storage: :s3,
    bucket: 'bonzoesc-tweet-archive',
    s3_credentials: {
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
end
