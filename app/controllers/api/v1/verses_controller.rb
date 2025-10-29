class Api::V1::VersesController < ApplicationController
  def search
    catergory = params["params"]
    if category
      Verse.joins(:tags).where(tags: { name: catergory.capitalize })
    else

    end

  end
end
