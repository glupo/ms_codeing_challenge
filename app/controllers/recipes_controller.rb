class RecipesController < ApplicationController

  def index
    @recipes = Contentful::Objects::Recipe.load
  end

  def show
    @recipe = Contentful::Objects::Recipe.find(show_params)
  end

  private

  def show_params
    params.require(:id)
  end
end
