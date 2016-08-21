class CheckPrStatusJob < ApplicationJob
  queue_as :default

  def perform(auto_merge)
    auto_merge.check_pr_status
    unless auto_merge.mergeable?
      auto_merge.enqueue_check_pr_status
    end
  end
end
