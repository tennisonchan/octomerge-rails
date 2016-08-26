class CreateAutoMerges < ActiveRecord::Migration[5.0]
  def change
    create_table :auto_merges do |t|
      t.integer :user_id
      t.string :owner
      t.string :repo
      t.string :pr_number
      t.string :state
      t.string :ref
      t.string :job_id
      t.datetime :last_updated

      t.timestamps
    end
    add_index :auto_merges, :user_id
    add_index :auto_merges, :pr_number
    add_index :auto_merges, :state
  end
end
