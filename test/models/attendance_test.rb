# == Schema Information
#
# Table name: attendances
#
#  id                 :integer          not null, primary key
#  stripe_customer_id :string
#  user_id            :integer          not null
#  event_id           :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_attendances_on_event_id  (event_id)
#  index_attendances_on_user_id   (user_id)
#

require "test_helper"

class AttendanceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
