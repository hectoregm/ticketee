class Comment < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :author, class_name: 'User'
  belongs_to :state
  delegate :project, to: :ticket

  validates :text, presence: true

  scope :persisted, -> { where.not(id: nil) }
end
