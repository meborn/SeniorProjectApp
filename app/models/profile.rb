class Profile < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  has_attached_file :avatar, :styles => { :small => "150x150", :thuumb => "80x80" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_attached_file :wallpaper, :styles => { :small => "150x150", :large => "1000x387" }
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/
end
