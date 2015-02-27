
  @genes = Gene.all
  @genes.each do |gene|
    if ! gene.note_id.nil?
      note = Note.find( gene.note_id )
      note.table_name = "Gene"
      note.save
    end  # do
  end  # do

