class Hall < ApplicationRecord
  belongs_to :cinema
  has_many :movie_sessions
end
