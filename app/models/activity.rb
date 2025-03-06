class Activity < ApplicationRecord
  has_many :activities_events, dependent: :destroy
  has_many :events, through: :activities_events
  has_many :tasks, dependent: :destroy

  validates :title, :age, presence: true

  include PgSearch::Model

  pg_search_scope :search_by_title_and_description,
                  against: [:title, :description],
                  using: {
                    tsearch: { prefix: true }
                  }

  # You can add a search scope for genre here
  pg_search_scope :search_by_genre_and_title,
                  against: :title,
                  associated_against: {
                    genres: :genres
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
