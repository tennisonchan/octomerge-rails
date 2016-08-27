class AutoMergeStatusSerializer < ActiveModel::Serializer
  attributes :owner, :pr_number, :repo, :state, :statuses

  def statuses
    object.statuses&.map do |status|
      status.slice("state", "context", "target_url", "updated_at")
    end
  end
end
