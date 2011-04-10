class Post < ActiveRecord::Base
  belongs_to :user
  validates_associated :user
  validates :message, :presence => true
end
