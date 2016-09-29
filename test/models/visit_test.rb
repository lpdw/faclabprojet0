# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  date_visit :datetime
#  place_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
