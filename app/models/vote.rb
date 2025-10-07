class Vote < ApplicationRecord
  belongs_to :option

  validates :voter_ip, prensence: true

  validate :check_duplicate_votes_count

  private

  def check_duplicate_vote
    poll = option.poll

    existing_vote = vote.joins(:option)
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