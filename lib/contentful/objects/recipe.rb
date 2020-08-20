module Contentful
  module Objects
    class Recipe < Base
      field :title
      field :photo
      field :calories
      field :description
      field :chef
      field :tags, default: []
    end
  end
end
