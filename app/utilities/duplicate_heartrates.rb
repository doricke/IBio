
  heart_rate = Itype.where(name: "heart_rate").take



  actigraphs = MonitorDatum.where( itype_id: heart_rate.id).to_a

  actigraphs.each do |hrd|
    rates = MonitorDatum.where( attachment_id: hrd.attachment_id, start_time: hrd.start_time, itype_id: heart_rate.id ).to_a
    if rates.size > 1
      rates.each do |dups|
        puts "id: #{dups.id}\tdup: #{dups.instrument_id}\tfile: #{dups.attachment_id}\titype:#{dups.itype_id}\n"
      end  # do
      
      puts
    end  # if
  end  # do