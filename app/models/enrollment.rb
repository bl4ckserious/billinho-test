# frozen_string_literal: true

class Enrollment < ApplicationRecord
  after_create :create_invoice

  has_many :billings, dependent: :destroy
  belongs_to :institution
  belongs_to :student

  validates :amount, :installments, :due_day, presence: true
  validates :amount, comparison: { greater_than: 0 }
  validates :installments, comparison: { greater_than_or_equal_to: 1 }
  validates :due_day, numericality: { in: 1..31 }

  enum status: { credit_card: 'Cartão de crédito', boleto: 'Boleto' }

  private

  def create_invoice
    current_date = Date.today
    installments_amount = amount.to_f / installments
    due_dates = []

    installments.times do |i|
      due_date = next_due_date(current_date, i, due_dates)
      due_dates << due_date

      Billing.create(enrollment_id: id, amount: installments_amount, due_date:, status: :open)
    end
  end

  def next_due_date(current_date, index, due_dates)
    due_date = Date.new(current_date.year, current_date.month, due_day).advance(months: index)

    if due_date < current_date && index.zero?
      due_date.next_month
    elsif due_dates.include? due_date
      due_date.next_month
    else
      due_date
    end
  rescue StandardError
    current_date.end_of_month.advance(months: index)
  end
end
