class CreateFunctions < ActiveRecord::Migration
  def change
    create_table :functions do |t|

      t.timestamps
    end
  end
end
