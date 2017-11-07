class Attachment < ActiveRecord::Base
  belongs_to :tweet

  has_attached_file :file,
            hash_secret: 'brick parker',
            hash_data: ':class/:attachment/:id',
            path: ':hash/:style.:extension'
  validates :file,
            attachment_presence: true,
            attachment_content_type: { content_type: %w{image/jpeg} }
end
