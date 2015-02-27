
  heart_rate = Itype.where(name: "heart_rate").take

  polar = Instrument.where(name: "PolarLoop" ).take
  mio = Instrument.where(name: "MioLink").take

  actigraphs = MonitorDatum.where( itype_id: heart_rate.id, instrument_id: polar.id).to_a

  actigraphs.each do |hrd|
      rates = MonitorDatum.where( individual_id: hrd.individual_id, end_time: hrd.end_time, start_time: hrd.start_time, itype_id: heart_rate.id ).to_a
    if rates.size > 1
      rates.each do |dups|
        puts "id: #{dups.id}\tdup: #{dups.instrument_id}\tfile: #{dups.attachment_id}\titype:#{dups.itype_id}\n"
      end  # do
      
      puts
    end  # if
  end  # do