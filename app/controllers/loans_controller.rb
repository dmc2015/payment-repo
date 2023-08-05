class LoansController < ActionController::API
  before_action :find, only: [:show, :create_payment, :loan_payment, :loan_payments] 

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  private
  def find
    @loan = params.keys.include?("id") ? Loan.find(params[:id]) : Loan.find(params[:loan_id])
  end

  # I would put most of thise in a module and use it as a mixin
  def failed_response(error)
    render json: {
      error: "Failed to create payment; #{error.to_s}",
      status: 400
    }, status: 400
  end

  def currency_formatting(amount)
    ActionController::Base.helpers.number_to_currency(amount)
  end

  def response_collection(collection)
    collection.map do |loan|
      {
        outstanding_balance: currency_formatting(loan.outstanding_balance),
        loan_data: loan.attributes,
        payments: loan.payments.map(&:attributes)
      }
    end
  end

  def response_obj(loan)
    { 
      outstanding_balance: currency_formatting(loan.outstanding_balance),
      loan_data: loan.attributes,
      payments: loan.payments.map(&:attributes)
    }
  end

  public
  def index
    render json: response_collection(Loan.all)
  end

  def show
    render json: response_obj(@loan)
  end

  def loan_payments
    render json: @loan.payments
  end

  def loan_payment
    render json: @loan.payments.where(id: params[:payment_id])
  end

  def create_payment
    begin
      payment = Payment.create!(loan: @loan, amount: params[:amount])
      render json: payment 
    rescue ActiveRecord::RecordInvalid => error
      failed_response(error)
    end
  end
end
