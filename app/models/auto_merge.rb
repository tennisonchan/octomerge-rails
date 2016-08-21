class AutoMerge < ApplicationRecord
  after_commit on: [:create] do
    delay.get_pr_details
  end

  belongs_to :user

  def pull_request
    @pull_request ||= user.client.pull_request("#{owner}/#{repo}", pr_number)
  end

  def pr_commit
    @pr_commit ||= user.client.combined_status("#{owner}/#{repo}", ref)
  end

  def get_pr_details
    self.ref = pull_request.head.ref

    save
  end

  def delay_check_pr_status
    CheckPrStatusJob.perform_later(self)
  end

  def check_pr_status
    # @pull_request ||= self.user.client.pull_request(self.repo, self.pr_number)
    pull_request
  end
end
