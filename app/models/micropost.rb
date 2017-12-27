class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_length_content}
  validate  :picture_size

  scope :created_at_desc, ->{order created_at: :desc}

  private

  def picture_size
    return unless picture.size > 1.5.megabytes
    errors.add(:picture, I18n.t(:notify_picture_size))
  end
end
