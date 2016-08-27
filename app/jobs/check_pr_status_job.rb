class CheckPrStatusJob < ApplicationJob
  queue_as :default

  def perform(auto_merge)
    if auto_merge.pr_commit.state == 'success' || auto_merge.pr_commit.total_count == 0
      auto_merge.merge_pull_request
    elsif 30.minutes.ago < auto_merge.last_updated
      auto_merge.delay_check_pr_status
    else
      auto_merge.update(state: 'timeout', last_updated: Time.now)
    end
  end
end
