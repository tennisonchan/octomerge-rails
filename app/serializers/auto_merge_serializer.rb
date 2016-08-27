class AutoMergeSerializer < ActiveModel::Serializer
  attributes :owner, :pr_number, :repo, :state, :last_updated
end
