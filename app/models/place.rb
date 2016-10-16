# == Schema Information
#
# Table name: places
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Place < ApplicationRecord
  has_many :visits
  validates :name,  :presence => true,
                    :length   => {:minimum => 4, :maximum => 55}
end
