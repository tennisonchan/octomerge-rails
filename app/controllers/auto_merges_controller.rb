class AutoMergesController < ApplicationController
  def create
    User.build_auto_merge()
  end

  private

  def auto_merge_params
    params
  end
end
