class AutoMerge < ApplicationRecord
  after_commit on: [:create] do
    delay.get_pr_details
  end

  belongs_to :user

  def owner_repo
    "#{owner}/#{repo}"
  end

  def pull_request
    @pull_request ||= user.client.pull_request(owner_repo, pr_number)
  end

  def pr_commit
    @pr_commit ||= user.client.combined_status(owner_repo, ref)
  end

  def get_pr_details
    self.ref = pull_request.head.ref

    save
  end

  def delay_check_pr_status
    CheckPrStatusJob.perform_later(self)
  end

  def merge_pull_request
    user.client.merge_pull_request(owner_repo, pr_number)
  end
end
