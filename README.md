IBio
====

Integrated Biomedical System (IBio)

  The Integrated Biomedical System is designed for integrating genome, interactome, and exposome data.

Setup

1. Install ruby
2. Install rubygem
3. Install rails
4. Create IBio database in any Rails supported relational database system
5. Modify config/database.yml file to select database of interest (i.e., MYSQL, etc.); default is Sqlite3 for easy installation
6. bundle install
7. Use "rake secret" or "bundle exec rake secret" and set value generated as environment variable for SECRET_TOKEN - used for Rails Cookies
8. Create the IBio database with "rake db:migrate"
9. Start a local instance with "rails server" 
10. Can be set up with Apache and Passenger or alternate deployments as a web application
