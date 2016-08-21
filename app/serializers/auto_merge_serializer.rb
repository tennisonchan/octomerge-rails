class AutoMergeSerializer < ActiveModel::Serializer
  attributes :owner, :pr_number, :repo, :status, :important, :user
end
