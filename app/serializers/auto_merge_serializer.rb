class AutoMergeSerializer < ActiveModel::Serializer
  attributes :owner, :pr_number, :repo, :state, :last_updated, :is_owner, :auto_merge_by

  def is_owner
    current_user.id == object.user_id
  end

  def auto_merge_by
    User.find(object.user_id)&.name
  end
end
