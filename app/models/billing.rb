# frozen_string_literal: true

class Billing < ApplicationRecord
  belongs_to :enrollment

  validates :amount, :due_date, :status, presence: true
  enum status: { open: 'Aberta', pending: 'Atrasada', paid: 'Paga' }
end
