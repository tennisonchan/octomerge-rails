require 'sidekiq/api'

class AutoMerge < ApplicationRecord
  extend Enumerize

  enumerize :state, in: [:pending, :timeout, :success, :failure], default: :pending

  belongs_to :user

  after_commit :delay_get_pr_details, on: [:create]
  before_destroy :clear_delay_job

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
    update(ref: pull_request.head.ref, last_updated: pull_request.updated_at)
    delay_check_pr_status
  end

  def delay_get_pr_details
    delay.get_pr_details
  end

  def delay_check_pr_status
    job = CheckPrStatusJob.set(wait: 2.minutes).perform_later(self)

    update(
      job_id: job.job_id,
      statuses: pr_commit.statuses.collect(&:to_h),
      last_updated: pr_commit.statuses.first&.updated_at
    )
  end

  def merge_pull_request
    user.client.merge_pull_request(owner_repo, pr_number)
  end

  def clear_delay_job
    job = Sidekiq::Queue.new.find_job(job_id)
    job.delete if job.present?
  end
end
