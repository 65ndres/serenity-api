class Api::V1::VersesController < ApplicationController
  include Pagy::Backend

  def search
    scope = Verse.all
    if params[:category].present?
      scope = scope.joins(:tags).where(tags: { name: params[:category].capitalize })
    end

    @pagy, @verses = pagy(scope, items: per_page, count: false)
    render json: {
      verses: @verses,
      pagination: pagy_metadata(@pagy)
    }
  end

  private

  def per_page
    (params[:per] || 15).to_i.clamp(1, 100)
  end

  def pagy_metadata(pagy)
    {
      page:    pagy.page
    }
  end
end
