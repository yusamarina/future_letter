# == Schema Information
#
# Table name: letters
#
#  id          :bigint           not null, primary key
#  body        :text             not null
#  image       :string
#  send_date   :datetime         not null
#  sender_name :string
#  title       :string           not null
#  token       :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  template_id :bigint
#  user_id     :bigint           not null
#
# Indexes
#
#  index_letters_on_template_id  (template_id)
#  index_letters_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates.id)
#  fk_rails_...  (user_id => users.id)
#
class Letter < ApplicationRecord
  mount_uploader :image, ImageUploader

  has_many :send_letters, dependent: :destroy
  belongs_to :user
  # belongs_to :template

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }
  validates :body, presence: true, length: { maximum: 1000 }
  validates :sender_name, length: { maximum: 30 }
  validates :send_date, presence: true
  validates :token, presence: true
  validate :send_date_check
  # validates :template_id, presence: true

  def send_date_check
    if send_date.blank?
      errors.add(:send_date, 'を設定してください')
    elsif self.send_date == nil
      errors.add(:send_date, 'を設定してください')
    elsif self.send_date < Time.now
      errors.add(:send_date, 'は未来の時間を選択してください')
    elsif self.send_date > Time.zone.local(2023, 7, 31, 23, 59)
      errors.add(:send_date, 'は2023年7月31日23時までの時間を選択してください')
    end
  end
end
