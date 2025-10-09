class Poll < ApplicationRecord
    has_many :options, dependent: :destroy

    validates :title, presence: true, length: { minimum: 5, maximum: 200}

    accepts_nested_attributes_for :options,
                                   reject_if: :all_blank,
                                   allow_destroy: true
    

    def total_votes
        options.sum(:votes_count) 
    end                              

end
