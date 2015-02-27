require 'input_file.rb'

class MiTracksClean
  
  ###############################################################################
  def clean_data( data_entry_id )
    puts "Cleaning for #{data_entry_id}"
    
    individual = Individual.find_by_data_entry_id( data_entry_id )
    
    itype = Itype.find_by_name( "My Tracks app" )
    activities = Activity.where(individual_id: individual.id, itype_id: itype.id).to_a
    
    first_name = {}
    activities.each do |activity|
      if first_name[ activity.activity_name ].nil?
        first_name[ activity.activity_name ] = true
      else
        puts "Duplicate: #{activity.activity_name}"
        locations = Location.where(activity_id: activity.id).to_a
        locations.each do |location|
          location.destroy
        end  # do
        
        attachment = Attachment.find(activity.attachment_id)
        attachment.destroy
        activity.destroy
      end  # do
    end  # if
  end #load_data

end #class

###############################################################################

def main_method
  app = MiTracksClean.new
  app.clean_data( ARGV[0].delete( '"' ) )
end  # main_method

###############################################################################

main_method
