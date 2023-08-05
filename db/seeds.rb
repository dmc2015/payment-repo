Loan.create!(funded_amount: 100.0)

l = Loan.create!(funded_amount: 200.20)
p1 = Payment.create!(loan: l, amount: 70)
p2 = Payment.create!(loan: l, amount: 50.50)
# p3 = Payment.create(loan: l, amount: 90.50)
