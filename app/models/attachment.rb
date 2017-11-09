class Attachment < ActiveRecord::Base
  belongs_to :tweet

  has_attached_file :file
  validates :file,
            attachment_presence: true,
            attachment_content_type: { content_type: %w{image/jpeg video/mp4} }
end
