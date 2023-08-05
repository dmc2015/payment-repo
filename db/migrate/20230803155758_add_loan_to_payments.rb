class AddLoanToPayments < ActiveRecord::Migration[5.2]
  def up
    add_reference :payments, :loan, index: true, foreign_key: true
  end

  def down
    remove_reference :payments, :loan, index: true, foreign_key: true
  end
end
