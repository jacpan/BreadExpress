class ItemPricesController < ApplicationController
  before_action :set_item_price, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /item_prices
  # GET /item_prices.json
  def index
    @item_prices = ItemPrice.all
  end

  # GET /item_prices/1
  # GET /item_prices/1.json
  def show
  end

  # GET /item_prices/new
  def new
    @item_price = ItemPrice.new
  end

  # GET /item_prices/1/edit
  def edit
  end

  # POST /item_prices
  # POST /item_prices.json
  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.today

    respond_to do |format|
      if @item_price.save
        format.html { redirect_to item_path(@item_price.item), notice: 'Price successfully added.' }
        format.json { render action: 'show', status: :created, location: @item_price }
      else
        format.html { redirect_to item_path(@item_price.item), alert: 'Price needs to be a number.' }
      end
    end
  end

  # PATCH/PUT /item_prices/1
  # PATCH/PUT /item_prices/1.json
  def update
    respond_to do |format|
      if @item_price.update(item_price_params)
        format.html { redirect_to @item_price, notice: 'Item price was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /item_prices/1
  # DELETE /item_prices/1.json
  def destroy
    @item_price.destroy
    respond_to do |format|
      format.html { redirect_to item_prices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item_price
      @item_price = ItemPrice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_price_params
      params.require(:item_price).permit(:price, :item_id)
    end
end
