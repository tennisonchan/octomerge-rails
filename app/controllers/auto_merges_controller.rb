class AutoMergesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @pending_auto_merges = current_user.auto_merges.where(state: 'pending')
    @total_count = current_user.auto_merges.count

    respond_to do |format|
      format.json {
        render json: @pending_auto_merges, each_serializer: AutoMergeStatusSerializer
      }
      format.html
    end
  end

  def show
    auto_merge = AutoMerge.find_by(pr_number: params[:id], state: 'pending')

    render json: auto_merge
  end

  def create
    auto_merge = current_user.auto_merges.build(auto_merge_params)

    if auto_merge.save!
      render json: auto_merge
    end
  end

  def destroy
    auto_merge = current_user.auto_merges.find_by(pr_number: params[:id])

    auto_merge.sync_with_pr_commit
    auto_merge.update(state: 'cancel')

    head :no_content
  end

  private

  def auto_merge_params
    params.require(:pathData).permit(:owner, :repo, :pr_number)
  end
end
