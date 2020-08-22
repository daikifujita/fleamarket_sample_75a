class Card < ApplicationRecord
  belongs_to :users, optional: true
end
