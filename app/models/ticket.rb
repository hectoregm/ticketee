class Ticket < ActiveRecord::Base
  before_create :assign_default_state
  validates :name, presence: true
  validates :description, presence: true, length: { minimum: 10 }

  belongs_to :project
  belongs_to :author, class_name: 'User'
  belongs_to :state
  has_many :attachments, dependent: :destroy
  has_many :comments, dependent: :destroy

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  private

  def assign_default_state
    self.state ||= State.default
  end
end
