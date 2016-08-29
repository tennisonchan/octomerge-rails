class CheckPrStatusJob < ApplicationJob
  queue_as :default

  def perform(auto_merge)
    auto_merge.sync_with_pr_commit

    if auto_merge.pending?
      auto_merge.delay_check_pr_status
    elsif auto_merge.success?
      auto_merge.merge_pull_request
    end
  end
end
