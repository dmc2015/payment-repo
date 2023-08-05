class PaymentsController < ApplicationController

  private
  # I would put most of thise in a module and use it as a mixin
  def failed_response(error)
    render json: {
      error: "Failed to create payment; #{error.to_s}",
      status: 400
    }, status: 400
  end

  public
  def show
    render json: Payment.find(params[:id])
  end

  def index
    render json: Payment.all
  end

  def create
    begin
      loan = Loan.find(params[:loan_id])
      payment = Payment.create!(loan: loan, amount: params[:amount])
      render json: payment 
    rescue ActiveRecord::RecordInvalid => error
      failed_response(error)
    end
  end
end
