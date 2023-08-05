require 'rails_helper'

RSpec.describe PaymentsController, type: :controller do
  describe "#create_payment" do
    before :each do
      @loan = Loan.create!(funded_amount: 100.0)
    end

    it 'responds with a 200' do
      params = { loan_id: @loan.id, amount: 20 }
      post :create, format: :json, params: params
      
      expect(response).to have_http_status(:ok)
    end

    
    it 'creates a payment' do
      expect(@loan.payments.count).to eq(0)

      post :create, params: { loan_id: @loan.id, amount: 20}
      @loan.reload

      expect(@loan.payments.count).to eq(1)
    end

    it 'will not create a payment over the total of the loan' do
      expect(@loan.payments.count).to eq(0)

      post :create, params: { loan_id: @loan.id, amount: 100.01}
      @loan.reload

      expect(@loan.payments.count).to eq(0)
    end

    it 'will raise an error when creating a payment over the total of the loan' do
      error = {"error"=>"Failed to create payment; Validation failed: Payment error The payment amount is too much", "status"=>400}
      post :create, params: { loan_id: @loan.id, amount: 100.01}
    
      expect(JSON.parse(response.body)).to eq(error)
    end
  end
end
