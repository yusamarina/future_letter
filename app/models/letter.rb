class Letter < ApplicationRecord
  has_many :send_letters, dependent: :destroy
  belongs_to :user
  # belongs_to :template

  validates :user_id, presence: true
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
    end
  end
end
