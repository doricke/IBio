class DrugReactionsController < ApplicationController
  before_action :set_drug_reaction, only: [:show, :edit, :update, :destroy]

  # GET /drug_reactions
  # GET /drug_reactions.json
  def index
    @drug_reactions = DrugReaction.all
  end

  # GET /drug_reactions/1
  # GET /drug_reactions/1.json
  def show
  end

  # GET /drug_reactions/new
  def new
    @drug_reaction = DrugReaction.new
  end

  # GET /drug_reactions/1/edit
  def edit
  end

  # POST /drug_reactions
  # POST /drug_reactions.json
  def create
    @drug_reaction = DrugReaction.new(drug_reaction_params)

    respond_to do |format|
      if @drug_reaction.save
        format.html { redirect_to @drug_reaction, notice: 'Drug reaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @drug_reaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @drug_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drug_reactions/1
  # PATCH/PUT /drug_reactions/1.json
  def update
    respond_to do |format|
      if @drug_reaction.update(drug_reaction_params)
        format.html { redirect_to @drug_reaction, notice: 'Drug reaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @drug_reaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drug_reactions/1
  # DELETE /drug_reactions/1.json
  def destroy
    @drug_reaction.destroy
    respond_to do |format|
      format.html { redirect_to drug_reactions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_drug_reaction
      @drug_reaction = DrugReaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def drug_reaction_params
      params.require(:drug_reaction).permit(:drug_id, :pathway_id, :reaction_id)
    end
end
