
  heart_rate = Itype.where(name: "heart_rate").take

actigraph = Instrument.where(name: "Actigraph").take

actigraphs = MonitorDatum.where( itype_id: heart_rate.id, instrument_id: actigraph.id).to_a

actigraphs.each do |hrd|
    rates = MonitorDatum.where( attachment_id: hrd.attachment_id, start_time: hrd.start_time ).to_a
    if rates.size > 1
      instr_id = nil
      rates.each do |dups|
        instr_id = dups.instrument_id if dups.instrument_id != actigraph.id
        puts "#{dups.id}\t#{dups.instrument_id}\t#{dups.attachment_id}\n"
      end  # do
      
      # Drop actigraph duplicates.
      if ! instr_id.nil?
        rates.each do |dups|
          dups.delete if dups.instrument_id == actigraph.id
        end  # do
      end  # if
      
      puts
    end  # if
end  # do