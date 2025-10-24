class Api::V1::VersesController < ApplicationController
  def search
    verses = Verse.all
    render json: verses
  end
end
