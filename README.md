# Marley Spoon coding challenge

## Implementation requirements:
 - Create a sample web application that uses the Contentful API to fetch data
 - You can choose to write the application in Ruby and any of its frameworks
 - There should be 2 views: 1) a list view of all the recipes & 2) A detail view of a recipe
 - When clicking on a recipe on the list view, you should then show the detailed view
 - The application should be as production-ready as possible, but no deployment is needed

## Data to render
### List view
- Display a preview of all recipes, including:
  - Title
  - Image

### Details View
- Display all the data for a recipe:
  - Title
  - Image
  - List of Tags
  - Description
  - Chef Name

## Requirements
- Installed software
  - `node v.10.17+`
  - `yarn v1.15+`
  - `ruby v2.7.1`
  - `bundler v2.1.4`
### Running development server
1. Either do `echo 52a2c54224987147f6e08db3dde73004 > ./config/master.key` to use existing credentials or do:
```
rm config/credentials.yml.enc
rails credentials:edit
```
and provide contentful credentials. Expected format is:
```
contentful:
  space_id: #{space_id}
  environment_id: #{environment_id}
  access_token: #{access_token}
```
2. `bundle install`
3. `yarn install`
4. `yart start`
5. `rails s` - in separate console

### Running production server
1. Steps 1 - 3 from development
2. `rails assets:precompile`
3. `rails s -e production`

### Running specs
`rspec`

### Comments
This project could benefit from caching Contentful calls, better coverage and some design enhancement
