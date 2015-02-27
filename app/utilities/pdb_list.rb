
  structures = Structure.all
  structures.each do |pdb|
    puts "#{pdb.name}"
  end  # do