class Api::V1::VersesController < ApplicationController
  include Pagy::Backend

  def search
    scope = Verse.all
    if params[:category].present? && params[:category] != "his_will"
      scope = scope.joins(:tags).where(tags: { name: params[:category].capitalize })
    end

    @pagy, @verses = pagy(scope, items: per_page)

    # Include liked status if user is authenticated
    verses_data = @verses.map do |verse|
      verse_data = verse.as_json
      if current_user
        interaction = current_user.user_interactions.find_by(verse: verse)
        verse_data['liked'] = interaction&.liked || false
      else
        verse_data['liked'] = false
      end
      verse_data
    end

    render json: {
      verses: verses_data,
      pagination: pagy_metadata(@pagy)
    }
  end

  def liked
    @pagy, @verses = pagy(Verse.where(favorite: true), items: per_page)

    render json: {
      verses: @verses,
      pagination: pagy_metadata(@pagy)
    }
  end

  def toggle_like
    verse = Verse.find(params[:id])
    binding.irb
    interaction = current_user.user_interactions.find_or_initialize_by(verse: verse)
    
    if interaction.persisted? && interaction.liked?
      interaction.update(liked: false)
      liked = false
    else
      interaction.liked = true
      interaction.save
      liked = true
    end
    
    render json: { liked: liked, message: liked ? 'Verse liked' : 'Verse unliked' }, status: :ok
  end

  private

  def per_page
    (params[:per] || 3).to_i.clamp(1, 100)
  end

  def pagy_metadata(pagy)
    {
      page: pagy.page,
      per_page: pagy.items,
      pages: pagy.pages,
      count: pagy.count,
      prev: pagy.prev,
      next: pagy.next
    }
  end
end
