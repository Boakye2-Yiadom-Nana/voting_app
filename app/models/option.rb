class Option < ApplicationRecord

    belongs_to :poll

    has_many :votes, dependent: :destroy


    validates :content, presence: true, length: { minimum: 1, maximum: 100 }

    def percentage
        return 0 if poll.total_votes.zero?

        (votes_count.to_f / poll.total_votes * 100).round(1)
    end