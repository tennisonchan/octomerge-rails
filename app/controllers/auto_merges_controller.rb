class AutoMergesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    auto_merge = current_user.auto_merges.find_by(pr_number: params[:id])

    render json: auto_merge.to_json
  end

  def create
    auto_merge = current_user.auto_merges.build(auto_merge_params)

    if auto_merge.save!
      render json: auto_merge.to_json
    end
  end

  def destroy
    auto_merge = current_user.auto_merges.find_by(pr_number: params[:id])

    auto_merge.destroy

    head :no_content
  end

  private

  def auto_merge_params
    params.require(:pathData).permit(:owner, :repo, :pr_number)
  end
end
