class PurchaseOrdersController < ApplicationController
  before_action :authenticate_user!

  def show #specify PO
    id = params[:id]
    @purchase_order = PurchaseOrder.find(id)
    #@ allows us to pass to view
  end

end
