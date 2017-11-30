class AutoMergesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @pending_auto_merges = current_user.auto_merges.where(state: 'pending')
    @closed_auto_merges = current_user.auto_merges.where.not(state: 'pending')
    @total_count = current_user.auto_merges.count

    if params[:pending] == "1"
      @auto_merges = @pending_auto_merges
    elsif params[:closed] == "1"
      @auto_merges = @closed_auto_merges
    end

    respond_to do |format|
      format.json {
        render json: @auto_merges, each_serializer: AutoMergeStatusSerializer
      }
      format.html
    end
  end

  def show
    auto_merge = AutoMerge.find_by(pr_number: params[:id], state: 'pending')

    render json: auto_merge
  end

  def create
    auto_merge = current_user.auto_merges.find_or_initialize_by(auto_merge_params.merge(state: 'pending', last_updated: Time.zone.now))

    if auto_merge.save!
      render json: auto_merge
    end
  end

  def destroy
    auto_merge = current_user.auto_merges.find_by(pr_number: params[:id], state: 'pending')

    auto_merge.sync_with_pr_commit
    auto_merge.update(state: 'cancel')

    head :no_content
  end

  private

  def auto_merge_params
    params.permit(:owner, :repo, :pr_number, :commit_message, :commit_title)
  end
end
