IBio
====

<h1>Integrated Biomedical System (IBio)</h1>

  The Integrated Biomedical System is designed for integrating genome, interactome, and exposome data.  Personal health is a dynamic state affected by genome, interactome, and exposome.  Wearable body sensors enable dynamic physiological and exposome monitoring.  Available solutions for integrating and displaying correlated individual data are either closed/proprietary platforms that provide limited access to sensor data or have limited scope that focuses primarily on one data domain (e.g., steps/calories/activity, etc.).  The Integrated Biomedical System is under development as an adaptable open-source solution for the burden associated with integrating heterogeneous data from a rapidly changing set of body sensors.  The Integrated Biomedical System provides a solution for individuals or a scalable platform for longitudinal research studies.

<h2>IBio Vision</h2>

<img src="https://github.com/doricke/IBio/blob/master/public/IBio_Vision.png?raw=true">

<h2>Setup</h2>

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
