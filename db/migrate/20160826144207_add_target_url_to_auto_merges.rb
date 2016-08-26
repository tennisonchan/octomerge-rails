class AddTargetUrlToAutoMerges < ActiveRecord::Migration[5.0]
  def change
    add_column :auto_merges, :target_urls, :string, array: true
  end
end
