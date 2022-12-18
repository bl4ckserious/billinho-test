# frozen_string_literal: true

class Billing < ApplicationRecord
  belongs_to :enrollment

  validates :amount, :due_date, :status, presence: true
  enum status: { open: 'Aberta', pending: 'Atrasada', paid: 'Paga' }

  def as_json(options = {})
    super(options).tap do |json|
      json['due_date'] = due_date.strftime('%d/%m/%Y')
    end
  end
end
