class Bot < ActiveRecord::Base
	belongs_to :user

	validates_presence_of :code, :name
end
