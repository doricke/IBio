
  @notes = Note.all
  comments = {}
  @notes.each do |note|
    if comments[note.comment].nil?
      comments[ note.comment ] = note.id
    else
      sleeps = Sleep.find_all_by_note_id( note.id )
      if ( sleeps.size > 0 )
        sleeps.each do |sleep|
          sleep.note_id = comments[ note.comment ]
          sleep.save
        end  # do
        note.destroy
      else
        puts "Duplicate note: #{note.comment}"
      end  # if
    end  # if
  end  # do
      
