class Client < ActiveRecord::Base
  belongs_to :owner, :class_name => 'User', :foreign_key => 'owner_id'
  belongs_to :client, :class_name => 'User', :foreign_key => 'client_id'
  belongs_to :profile
end