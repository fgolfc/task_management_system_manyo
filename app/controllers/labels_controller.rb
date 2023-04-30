class LabelsController < ApplicationController
  before_action :set_label, only: [ :show, :edit, :update, :destroy ]

  # GET /labels or /labels.json
  def index
    @search_params = label_search_params
    @labels = current_user.labels.search(@search_params)
  end  

  # GET /labels/1 or /labels/1.json
  def show
  end

  # GET /labels/new
  def new
    @label = Label.new
  end

  # GET /labels/1/edit
  def edit
  end

  # POST /labels or /labels.json
  def create
    @label = Label.new(label_params)
    @label.user = current_user
  
    respond_to do |format|
      if @label.save
        format.html { redirect_to labels_path, notice: t('.created') }
        format.json { render :show, status: :created, location: @label }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end  

  # PATCH/PUT /labels/1 or /labels/1.json
  def update
    respond_to do |format|
      if @label.update(label_params)
        format.html { redirect_to labels_path, notice: t('.updated') }
        format.json { render :show, status: :ok, location: @label }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @label.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /labels/1 or /labels/1.json
  def destroy
    @label.destroy
    respond_to do |format|
      format.html { redirect_to labels_url, notice: t('.destroyed') }
      format.json { head :no_content }
    end
  end

  private

    def set_label
      @label = current_user.labels.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'ラベルが見つかりませんでした'
      redirect_to labels_path
    end

    # Only allow a list of trusted parameters through.
    def label_params
      params.require(:label).permit(:name)
    end

    # Define label search parameters
    def label_search_params
      params.fetch(:search, {}).permit(:name_cont, :label_id_is)
    end
end