# require 'input_file.rb'
require 'tools.rb'

class SleepDump
  
  ###############################################################################
  def sleep_data( data_entry_id )
    
    individual = Individual.where( data_entry_id: data_entry_id ).take
    return if individual.nil?
    
    instrument = Instrument.where( name: "Basis watch" ).take
    
    itype = Itype.where( name: "Basis" ).take

    sleeps = Sleep.where(individual_id: individual.id).to_a
    instruments_hash = Tools::to_hash( Instrument.all )
    
    data = data_setup( sleeps )
    
    devices = {}
    sleeps.each do |sleep|
      devices[ sleep.instrument_id ] = true
    end  # do
    
    data_types = ['sleep', 'light sleep', 'deep sleep', 'REM sleep', 'interruptions']
    print( "date," )
    data_types.each do |name|
      devices.keys.each do |device|
        print "#{instruments_hash[device].name} #{name},"
      end  # do
    end  # do
    print "\n"
    
    data.each do |sleep_date, sleep_data|
      print( "#{sleep_date}," )
      data_types.each do |data_type|
        devices.keys.each do |device|
          if (! sleep_data[device].nil?) && (! sleep_data[device][data_type].nil?)
            print( "#{sleep_data[device][data_type]}," )
          else
            print( "," )
          end  # if
        end  # do
      end  # do
      print( "\n" )
    end  # do
  end # sleep_data
    
  ###############################################################################
  
  ##############################################################################
  def data_setup( sleeps )
    basis_watch = Instrument.where(name: "Basis watch").take
    
    data = {}
    
    sleeps.each do |sleep|
      sleep_date = "#{sleep.start_time.year}-#{sleep.start_time.mon}-#{sleep.start_time.day}"
      # puts "#{sleep_date} #{sleep.instrument_id} #{sleep.secs_asleep}}"
      data[ sleep_date ] = {} if data[ sleep_date ].nil?
      data[sleep_date][ sleep.instrument_id ] = {} if data[sleep_date][ sleep.instrument_id ].nil?
      
      if (sleep.secs_asleep > 0) && (sleep.instrument_id != basis_watch.id)
        data[sleep_date][ sleep.instrument_id ][ 'sleep' ] = sleep.secs_asleep.to_f / 3600.0
      else
        if (sleep.secs_asleep > 0)
          data[sleep_date][ sleep.instrument_id ][ 'sleep' ] = sleep.secs_asleep.to_f / 3600.0 if (! sleep.light_sleep.nil?)
        end  # if
      end  # if
      
      if (! sleep.light_sleep.nil?) && (sleep.light_sleep > 0)
        data[sleep_date][ sleep.instrument_id ][ 'light sleep' ] = sleep.light_sleep.to_f / 3600.0
      end  # if
      
      if (! sleep.deep_sleep.nil?) && (sleep.deep_sleep > 0)
        data[sleep_date][ sleep.instrument_id ][ 'deep sleep' ] = sleep.deep_sleep.to_f / 3600.0
      end  # if
      
      if (! sleep.rem_sleep.nil?) && (sleep.rem_sleep > 0)
        data[sleep_date][ sleep.instrument_id ][ 'REM sleep' ] = sleep.rem_sleep.to_f / 3600.0
      end  # if
      
      if (! sleep.interruptions.nil?) && (sleep.interruptions > 0)
        data[sleep_date][ sleep.instrument_id ][ 'interruptions' ] = sleep.interruptions
      end  # if
    end  # do
    
    # puts "#{data}"
    
    return data
  end  # data_setup
  
  ###############################################################################
  
end  # class

###############################################################################

def main_method
  app = SleepDump.new
  if ARGV.length >= 1
    app.sleep_data( ARGV[0].delete( '"' ) )
  end  # if
end  # main_method

main_method