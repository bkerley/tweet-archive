opts = {
  storage: :s3,
  url: ':s3_alias_url',
  s3_credentials: {
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    s3_region: 'us-east-1',
    bucket: 'bonzoesc-tweet-archive',
  },
  s3_host_alias: 'tam.bonzoesc.net',
  hash_secret: 'brick parker',
  hash_data: ':class/:attachment/:id',
  path: ':hash/:style.:extension',
  s3_protocol: 'https'
}

opts.each do |k,v|
  Paperclip::Attachment.default_options[k] = v
end
