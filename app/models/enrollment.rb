class Enrollment < ApplicationRecord
    after_create :create_invoice

    has_many :billings, dependent: :destroy
    belongs_to :institution
    belongs_to :student

    validates :amount, :installments, :due_day, presence: true
    validates :amount, comparison: {greater_than: 0}
    validates :installments, comparison: {greater_than_or_equal_to: 1}
    validates :due_day, comparison: {greater_than_or_equal_to: 1, less_than_or_equal_to: 31}

    private

    def create_invoice
        cur_d = Date.today
        sub_t = (amount / installments).ceil(2)
        count = 1
 
        while count <= installments

            begin
                if count == 1
                    due_d = Date.new(cur_d.year, cur_d.month, due_day)
                else
                    due_d = Date.new(due_d.year, due_d.month, due_day)
                end
            rescue => exception
                due_d = Date.new(due_d.year, due_d.month, -1)
            end

            if due_d >= cur_d && count == 1
                invoices = Billing.new(enrollment_id:id, amount: sub_t, due_date: due_d, status: :open)

                due_d = due_d.next_month
                invoices.save
            elsif due_d < cur_d && count == 1   
                due_d = due_d.next_month 

                invoices = Billing.new(enrollment_id:id, amount: sub_t, due_date: due_d, status: :open)

                due_d = due_d.next_month 
                invoices.save
            else
                invoices = Billing.new(enrollment_id:id, amount: sub_t, due_date: due_d, status: :open)

                due_d = due_d.next_month 
                invoices.save
            end
            
            count += 1
        end
    end
end
