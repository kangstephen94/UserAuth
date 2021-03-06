# == Schema Information
#
# Table name: cats
#
#  id          :bigint(8)        not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#

require 'action_view'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  # freeze ensures that constants are immutable
  CAT_COLORS = %w(black white orange brown).freeze

  validates :birth_date, :color, :name, :sex, :owner, presence: true
  validates :color, inclusion: CAT_COLORS
  validates :sex, inclusion: %w(M F)


  belongs_to :owner,
  class_name: 'User',
  foreign_key: :user_id,
  primary_key: :id

  has_many :rental_requests,
  class_name: :CatRentalRequest,
  dependent: :destroy

  def age
    time_ago_in_words(birth_date)
  end
end
