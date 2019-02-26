# == Schema Information
#
# Table name: cats
#
#  id          :bigint(8)        not null, primary key
#  birth_date  :date             not null
#  name        :string           not null
#  color       :string           not null
#  sex         :string(1)        not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'action_view'

class Cat < ApplicationRecord
  include ActionView::Helpers::DateHelper

  validates :birth_date, :name, :color, :sex, presence: true

  #TEST
  def age
    time_ago_in_words(self.birth_date)
  end



end
