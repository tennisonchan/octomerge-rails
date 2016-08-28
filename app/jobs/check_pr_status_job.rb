class CheckPrStatusJob < ApplicationJob
  queue_as :default

  def perform(auto_merge)
    if auto_merge.pr_commit.state == 'pending' && 30.minutes.ago < auto_merge.pull_request.updated_at
      auto_merge.delay_check_pr_status
    elsif auto_merge.pr_commit.state == 'success' || auto_merge.pr_commit.total_count == 0
      auto_merge.merge_pull_request
    end
  end
end
