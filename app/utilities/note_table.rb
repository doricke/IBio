
  @sleeps = Sleep.all
  @sleeps.each do |sleep|
    if ! sleep.note_id.nil?
      note = Note.find( sleep.note_id )
      note.table_name = "Sleep"
      note.save
    end  # if
  end  # do

  @diseases = Disease.all
  @diseases.each do |disease|
    if ! disease.note_id.nil?
      note = Note.find( disease.note_id )
      note.table_name = "Disease"
      note.save
    end  # do
  end  # do

  @sources = Source.all
  @sources.each do |source|
    source.table_name = "Biosequence"
    source.save
  end  # do
