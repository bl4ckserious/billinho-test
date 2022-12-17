# frozen_string_literal: true

class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.integer :student_id
      t.integer :institution_id
      t.float :amount
      t.integer :installments
      t.integer :due_day

      t.timestamps
    end

    add_foreign_key :enrollments, :students, column: :student_id
    add_foreign_key :enrollments, :institutions, column: :institution_id
  end
end
