class AddIndexToOwnerRepoOnAutoMerge < ActiveRecord::Migration[5.0]
  def change
    add_index :auto_merges, :owner
    add_index :auto_merges, :repo
  end
end
