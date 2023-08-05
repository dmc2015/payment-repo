class Loan < ActiveRecord::Base
  has_many :payments

  def self.funded_amount
    funded_amount.to_f
  end

  # I would consider moving this summing logic in to a module, its repeated here
  # and in the payments model
  def outstanding_balance
    funded_amount - (payments.map(&:amount).map(&:to_f).sum)
  end
end
