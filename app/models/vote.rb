class Vote < ApplicationRecord
  belongs_to :option, counter_cache: :votes_count

  validates :voter_ip, presence: true

  validate :check_duplicate_vote

  private

  def check_duplicate_vote
    poll = option.poll

    existing_vote = Vote.joins(:option)
                        .where(options: { poll_id: poll.id })
                        .where(voter_ip: voter_ip)
                        .exists?

    if existing_vote
      errors.add(:base, "You have already voted on this poll")
    end
end

def increment_option_votes_count

  option.increment!(:votes_count)
end
end