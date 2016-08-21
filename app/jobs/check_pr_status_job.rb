class CheckPrStatusJob < ApplicationJob
  queue_as :default

  def perform(auto_merge)
    if auto_merge.pr_commit.state == 'success'
      auto_merge.merge_pull_request
    else
      auto_merge.delay_check_pr_status
    end
  end
end
