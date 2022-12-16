class CreateBillings < ActiveRecord::Migration[7.0]
  def change
    create_table :billings do |t|
      t.integer :enrollment_id
      t.float :amount
      t.date :due_date
      t.string :status

      t.timestamps
    end

    add_foreign_key :billings, :enrollments, column: :enrollment_id
  end
end
