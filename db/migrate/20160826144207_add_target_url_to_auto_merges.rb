class AddTargetUrlToAutoMerges < ActiveRecord::Migration[5.0]
  def change
    add_column :auto_merges, :statuses, :json
  end
end
