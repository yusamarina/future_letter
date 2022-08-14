class Letter < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :send_letters, dependent: :destroy
  belongs_to :user
  # belongs_to :template

  validates :user_id, presence: true
  validates :title, presence: true
  validates :body, presence: true
  validates :send_date, presence: true
  validates :token, presence: true
  validate :send_date_check
  # validates :template_id, presence: true

  def send_date_check
    if send_date.blank?
      errors.add(:send_date, "を設定してください")
    elsif self.send_date == nil
      errors.add(:send_date, "を設定してください")
    elsif self.send_date < Time.now
      errors.add(:send_date, "は未来の時間を選択してください")
    elsif self.send_date > Time.zone.local(2023, 8, 31, 23, 59)
      errors.add(:send_date, "は2023年8月31日23時までの時間を選択してください")
    end
  end
end
