require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    let(:loan_2) { Loan.create!(funded_amount: 200.0) }

    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it 'contains multiple loans' do
      get :index
      expect(response.body.length).to eq(2)
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, params: { id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, params: { id: 10000 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "#loan_payments" do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    let!(:payment_one) { Payment.create!(loan: loan, amount: 20) }
    let!(:payment_two) { Payment.create!(loan: loan, amount: 40) }

    it 'responds with a 200' do
      get :loan_payments, params: { loan_id: loan.id }
      expect(response).to have_http_status(:ok)
    end

    it 'responds with payment data' do
      get :loan_payments, params: { loan_id: loan.id }
      data = JSON.parse(response.body) 

      expect(data[0].keys).to eq(Payment.column_names)
      expect(data[1].keys).to eq(Payment.column_names)
    end
  end

  describe "#loan_payment" do
    let(:loan) { Loan.create!(funded_amount: 100.0) }
    let!(:payment_one) { Payment.create!(loan: loan, amount: 20) }
    let!(:payment_two) { Payment.create!(loan: loan, amount: 40) }

    it 'responds with a 200' do
      get :loan_payment, params: { loan_id: loan.id, payment_id: payment_one.id}
      expect(response).to have_http_status(:ok)
    end

    it 'responds with payment data' do
      get :loan_payment, params: { loan_id: loan.id, payment_id: payment_one.id }
      data = JSON.parse(response.body) 

      expect(data.count).to eq(1)
      expect(data[0].keys).to eq(Payment.column_names)
      # expect(response.body).to eq([payment_one.to_json])
    end
  end
end
