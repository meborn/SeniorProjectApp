class Profile < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true
  validates :color, presence: true
  validates :zip, presence: true
  validates :zip, length: { is: 5 }

  has_attached_file :avatar, :styles => { :small => "150x150#", :thuumb => "80x80#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_attached_file :wallpaper, :styles => { :small => "150x1500#", :large => "1000x387#" }
  validates_attachment_content_type :wallpaper, :content_type => /\Aimage\/.*\Z/

  has_many :appointments
  has_many :cancellations
  has_many :openings
  has_many :clients
end
