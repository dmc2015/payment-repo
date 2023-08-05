class Payment < ActiveRecord::Base
  belongs_to :loan

  validates :loan_id, presence: true
  validates :amount, presence: true

  after_save :check_payment_amount

  private
  
  def total_payments
    reload
    loan.payments.map(&:amount).map(&:to_f).sum
  end

  def check_payment_amount
    return true if self.loan.funded_amount.to_f >= total_payments
    errors.add(:payment_error, "The payment amount is too much")
    raise ActiveRecord::RecordInvalid.new(self)
  end
end
