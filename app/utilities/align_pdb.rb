
require 'fasta_iterator.rb'
require 'fasta_sequence.rb'
require 'tuples.rb'

################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
################################################################################

# Author::      Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
         
################################################################################
# This class represents a protein multiple sequence alignment.
class AlignPdb

# FASTA file name
attr_accessor :fasta_name
# Protein multiple sequence alignment hash - hashed by sequence name
attr_accessor :msa
# Word tuples
attr_accessor :tuples
# Sequences
attr_accessor :seqs


################################################################################
def initialize
  @msa = {}
  @tuples = {}
  @seqs = {}
end  # initialize


################################################################################
# This method determines the consensus for a position.
def consensus
  cons = ""
  return cons
end  # method consensus


################################################################################
# This method reads in the FASTA sequences from the file.
def load_fastas( fasta_filename )
  @fasta_name = fasta_filename
  in_fasta = FastaIterator.new( fasta_filename )
  in_fasta.open_file
  @seqs = in_fasta.read_fastas
  return @seqs
end  # method load_fastas


################################################################################
def calculate_tuples
  @seqs.each do |name, fasta|
    tuples = Tuples.new
    tuples.calculate_words( fasta.sequence_data )
    @tuples[ fasta.sequence_name ] = tuples
  end  # do
end  # calculate_tuples


################################################################################
def compare_tuples( first )
  names = @seqs.keys()
  return if names.size < 2
  seq1 = @seqs[ first ].sequence_data
  # @msa[ first ] = @seqs[ first ].sequence_data
  for name in names[0..-1] do
    if ( name != first )
      # puts "Aligning: #{name}"
      seq2 = @seqs[ name ].sequence_data
      @tuples[ first ].calculate_common( @tuples[ name ].words, @tuples[ name ].words_positions )
      # @tuples[ first ].show_common_words( @tuples[ name ].words_positions )
      @msa[ name ] = @tuples[ first ].align_words( seq1, seq2, @tuples[ name ].words_positions, name )
      # puts
    end  # if
  end  # for
end  # compare_tuples


################################################################################
# This method drops in the insert sequence and gap fills to the width for this position.
def add_extra( ins_seq, width )
  seq = ins_seq
  count = ins_seq.length
  while ( count < width ) do
    seq << "."
    count += 1
  end  # while
  return seq
end  # add_extra


################################################################################
# This method adds the insert for this sequence or gaps where needed.
def add_inserts( align, inserts, widths, name )
  seq = ""
  return seq if (align.nil?) || (align.keys.size < 1 )
  for i in 1..align.keys.sort.last do
    if (! align[i].nil?)
      seq << align[i]
    else
      seq << "."
    end  # if

    ins_seq = ""
    ins_seq = inserts[i][name] if (! inserts[i].nil?) && (! inserts[i][name].nil?)
    seq << add_extra( ins_seq, widths[i] ) if (! widths[i].nil?)
  end  # for

  return seq
end  # add_inserts


################################################################################
# This method determines the insert maximum size at each position.
def size_inserts( inserts )
  widths = {}
  inserts.each do |pos, extras| 
    extras.each do |name, ins_seq|
      ins_size = ins_seq.size
      if ( widths[ pos ].nil? )
        widths[ pos ] = ins_size
      else
        # Check if next insert is larger than the previous at this position.
        widths[ pos ] = ins_size if ( ins_size > widths[ pos ] )
      end
    end  # do
  end  # do

  return widths
end  # size_inserts

################################################################################
def msa_snap( seq_name )
  names = @msa.keys
  print "Position\t"
  names.each do |name|
    print "#{name}\t"
  end  # do
  puts
  
  puts "#{seq_name}\t#{@msa[seq_name]}"
  
  @msa[ seq_name ].keys.sort.each do |pos|
    print "#{pos}\t"
    names.each do |name|
      if ! @msa[name][pos].nil?
        print "#{@msa[name][pos]}\t"
      else
        print "\t"
      end  # if
    end  # do
    puts
  end  # do
end  # method msa_snap

################################################################################
def record_residues( name, structure_id, chain, aa_length )
  msa_snap( name )
  puts "record_residues, Checking: #{name}"

  first_seq = @seqs[ name ].sequence_data
  target_name = name + "_" + chain
  return if @seqs[ target_name ].nil?
  return if aa_length.nil?
  target_seq = @seqs[ target_name ].sequence_data

  puts "First_seq: #{first_seq}"
  puts "Target: #{target_name} #{@msa[target_name]}"
  atoms = Atom.find_all_by_structure_id_and_chain( structure_id, chain, :order => :atom_start )
  atoms_index = 0
  start_index = @msa[ target_name ].keys.sort[0]
  # Check start of alignment.
  if ( ! @msa[target_name][start_index].nil? )
    start_seq = ""
    for i in start_index...(start_index+10) do
      start_seq << @msa[target_name][i] if ! @msa[target_name][i].nil?
    end  # do
    index = target_seq.upcase.index( start_seq.upcase )
    return if index.nil?
    atoms_index = index
    puts "Start seq: #{start_seq}, index: #{atoms_index}, start_index: #{start_index}"
  end  # if
  
  return if start_index.nil?
  if ( atoms.size > 0 )
    # puts "--> atoms found #{atoms.size}"
    # for i in start_index..aa_length do
    return if (start_index >= aa_length)
    for i in start_index..aa_length do
      return if ( atoms_index >= atoms.size )
      
      if (! @msa[target_name][i].nil?) && (atoms_index < first_seq.size) && ( @msa[ target_name ][ i ].downcase == @msa[ name ][ i ].downcase )
        atoms[ atoms_index ].update_attributes( aa_residue: i ) if ( atoms_index < atoms.size )
        puts "i: #{i} #{@msa[target_name][i]}|#{@msa[name][i]} ai:#{atoms_index}, Residue: #{atoms[atoms_index].residue}, Seq: #{target_seq[atoms_index]}, atom_start: #{atoms[atoms_index].atom_start}" if ( atoms_index < atoms.size )
        atoms_index += 1
      else
        if (! @msa[target_name][i].nil?) && ( @msa[ target_name ][ i ] != '.' )
          puts "i: #{i} #{@msa[target_name][i]}|#{@msa[name][i]} ai:#{atoms_index}, No Match: #{@msa[target_name][i]} #{target_seq[atoms_index]}, atoms_index: #{atoms_index}" if ( atoms_index < first_seq.size )

          atoms[ atoms_index ].update_attributes( aa_residue: i )  # Record, even though mismatch residue
          atoms_index += 1
        end  # if
      end  # if
    end  # for
  end  # if
end  # record_residues


################################################################################
def write_msa( first )
  names = @seqs.keys()
  first_seq = @seqs[ first ].sequence_data

  # Set up the alignment for the first sequence.
  @msa[first] = {}
  for i in 0...first_seq.length do
    @msa[first][i+1] = first_seq[i]
  end  # for 

  # Write out the alignment.
  inserts = @tuples[ first ].inserts
  gap_widths = size_inserts( inserts )
  for name in names do
    puts ">" + @seqs[name].sequence_name + " " + @seqs[name].sequence_description + "\n"
    align_seq = add_inserts( @msa[name], inserts, gap_widths, name )
    puts "#{SeqTools::to_blocks( align_seq )}"
  end  # for
end  # write_msa


################################################################################
def print_msa( first )
  names = @seqs.keys()
  first_seq = @seqs[ first ].sequence_data
  puts( first + "\t" + first_seq )
  for name in names[0..-1] do
    if ( name != first ) && (! @msa[name].nil?) && (@msa[name].keys.size > 0)
      print( name + "\t" )
      for i in 1..@msa[name].keys.sort.last do
        if @msa[ name ][ i ].nil?
          print( "." )
        else
          print( @msa[ name ][ i ] )
        end  # if 
      end  # for
      print( "\n" )
    end  # if
  end  # for 

  # Data check:
  # for name in names[1..-1] do
  #   puts( name + "\t" + @msa[name].sort.join )
  # end  # for
  
  # Print out the insertions.
  puts
  inserts = @tuples[ first ].inserts
  inserts.keys.sort.each do |pos|
    inserts[pos].each do |name, ins|
      puts "#{pos}  #{name}  #{ins}"
    end  # do
  end  # do
end  # print_msa

################################################################################

end  # class AlignPdb


################################################################################
def test_msa( filename )
  # puts "usage: ruby msa.rb msa2.fa\n" if ARGV.length < 1
  filename = ARGV[0] if ARGV.length >= 1
  app = AlignPdb.new
  pdb_seqs = app.load_fastas( filename )		# protein FASTA sequences

  parts = filename.split( '/' )
  tokens = parts[-1].split( '.' )
  pdb_name = tokens[0]
  puts "Aligning: #{pdb_name}"
  structure = Structure.find_by_name( pdb_name, :select => 'id,name' )
  structure_sequences = StructureSequence.find_all_by_structure_id( structure.id )
  structure_sequences.each do |structure_sequence|
    sequence = Biosequence.find( structure_sequence.biosequence_id )
    if ! sequence.aa_sequence.nil?
      seq_fasta = FastaSequence.new( pdb_name, "", sequence.aa_sequence, "AA" )
      puts "PDB: #{pdb_name}, chain: #{structure_sequence.chain}, seq: #{sequence.name} #{sequence.aa_sequence}"
      app.seqs[ pdb_name ] = seq_fasta

      # Set up the alignment for the first sequence.
      first_seq = sequence.aa_sequence
      app.msa[pdb_name] = {}
      for i in 0...first_seq.length do
        app.msa[pdb_name][i+1] = first_seq[i]
      end  # for
      
      # app.msa_snap( pdb_name )

      # puts "###### Before calculate_tuples"
      app.calculate_tuples
      app.msa_snap( pdb_name )

      # puts "##### Before compare tuples"
      app.compare_tuples( pdb_name )
      app.record_residues( pdb_name, structure.id, structure_sequence.chain, sequence.aa_sequence.size )
      app.print_msa( pdb_name )
      # app.write_msa( pdb_name )
    end  # if
  end  # do
end  # method test_msa


################################################################################
# test_msa( "f9" )
  test_msa( "2WPI" )
# test_msa( "tp53" )
# test_msa( "serine2.fa" )
