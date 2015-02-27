# require 'input_file.rb'
require 'tools.rb'

class HeartRateDump
  
  ###############################################################################
  def heart_rate_data( data_entry_id, start_date, end_date )
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    heart_rate_type = Itype.where(name: "heart_rate").take
    monitor_data = MonitorDatum.where(individual_id: individual.id, itype_id: heart_rate_type.id, points_per_hour: 60 ).to_a
    instruments_hash = Tools::to_hash(Instrument.all)
    
    devices = {}
    monitor_data.each do |monitor_datum|
      if ( ( monitor_datum.start_time >= start_date ) && ( monitor_datum.start_time <= end_date ) )
        devices[ monitor_datum.instrument_id ] = instruments_hash[ monitor_datum.instrument_id ].name
      end  # if
    end  # do
    
    data = data_setup( monitor_data, devices )
    
    print( "date," )
    devices.each do |id, name|
      print "#{name},"
    end  # do
    print "\n"
    
    date = start_date
    while (date <= end_date )
      print( date.strftime("%Y/%m/%d %H:%M") )
      print( "," )
      devices.each do |id, name|
        if (! data[id][date].nil?)
          print( "#{data[id][date]},")
        else
          print( "," )
        end  # if
      end  # do
      print( "\n" )
      date += 60
    end  # while
    
    #    data.each do |sleep_date, sleep_data|
    #  print( "#{sleep_date}," )
    #  data_types.each do |data_type|
    #    devices.keys.each do |device|
    #      if (! sleep_data[device].nil?) && (! sleep_data[device][data_type].nil?)
    #        print( "#{sleep_data[device][data_type]}," )
    #      else
    #        print( "," )
    #      end  # if
    #    end  # do
    #  end  # do
    #  print( "\n" )
    #end  # do
  end # sleep_data
    
  ###############################################################################
  
  ##############################################################################
  def data_setup( monitor_data, devices )
    # Set up the data structure by [ instrument_id ][ time ] = heart_rate
    data = {}
    devices.each do |id, name|
      data[id] = {}
    end  # do
    
    monitor_data.each do |monitor_datum|
      st = monitor_datum.start_time
      loop_time = Time::local( st.year, st.mon, st.day, st.hour, st.min )
      # puts "#{monitor_datum.instrument_id}\t#{devices[monitor_datum.instrument_id]}\t#{monitor_datum.data_vector}"
      data_vector = monitor_datum.data_vector.split( "," )
      data_vector.each do |beat|
        data[ monitor_datum.instrument_id ][ loop_time ] = beat.to_f if beat.size > 0
        loop_time += 60
      end  # do
    end  # do
    return data
  end  # data_setup
  
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = HeartRateDump.new
  start_date = Time::local( 2013, 8, 1 )
  end_date = Time::local( 2014, 12, 1 )
  if ARGV.length >= 1
    app.heart_rate_data( ARGV[0].delete( '"' ), start_date, end_date )
  end  # if
end  # main_method

main_method