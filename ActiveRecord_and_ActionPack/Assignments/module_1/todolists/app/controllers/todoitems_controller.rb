class TodoitemsController < ApplicationController
  before_action :set_todoitem, only: [:show, :edit, :update, :destroy]

  # GET /todoitems
  # GET /todoitems.json
  def index
    @todoitems = Todoitem.all
  end

  # GET /todoitems/1
  # GET /todoitems/1.json
  def show
  end

  # GET /todoitems/new
  def new
    @todoitem = Todoitem.new
  end

  # GET /todoitems/1/edit
  def edit
  end

  # POST /todoitems
  # POST /todoitems.json
  def create
    @todoitem = Todoitem.new(todoitem_params)

    respond_to do |format|
      if @todoitem.save
        format.html { redirect_to @todoitem, notice: 'Todoitem was successfully created.' }
        format.json { render :show, status: :created, location: @todoitem }
      else
        format.html { render :new }
        format.json { render json: @todoitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todoitems/1
  # PATCH/PUT /todoitems/1.json
  def update
    respond_to do |format|
      if @todoitem.update(todoitem_params)
        format.html { redirect_to @todoitem, notice: 'Todoitem was successfully updated.' }
        format.json { render :show, status: :ok, location: @todoitem }
      else
        format.html { render :edit }
        format.json { render json: @todoitem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todoitems/1
  # DELETE /todoitems/1.json
  def destroy
    @todoitem.destroy
    respond_to do |format|
      format.html { redirect_to todoitems_url, notice: 'Todoitem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todoitem
      @todoitem = Todoitem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def todoitem_params
      params.require(:todoitem).permit(:due_date, :title, :description, :completed)
    end
end
