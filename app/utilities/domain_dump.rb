
  domains = Domain.all

  domains.each do |domain|
    name = domain.name
    i = name.index( '.' )
    name = name[ 0...i ] if ! i.nil?
    name = name.gsub( ' ', '_' )
    name = name.delete("^a-zA-Z0-9_")
    
    out = OutputFile.new( "#{domain.id}_" + name + ".fa" )
    out.open_file()
    list = BiosequenceDomain.where(domain_id: domain.id).to_a
    list.each do |list_item|
      seq = Biosequence.find(list_item.biosequence_id)
      out.write( ">#{seq.name}\n" )
      out.write( "#{seq.aa_sequence[(list_item.seq_start-1)...list_item.seq_end]}\n" )
    end  # do
    out.close_file()
  end  # do