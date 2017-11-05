json.extract! attachment, :id, :tweet_id, :media_attachment_id, :index, :file, :created_at, :updated_at
json.url attachment_url(attachment, format: :json)
