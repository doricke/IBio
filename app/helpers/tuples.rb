
require 'fasta_sequence.rb'
require 'slide_align.rb'

################################################################################
# Copyright (C) 2015  Darrell O. Ricke, PhD
# Author::    	Darrell O. Ricke, Ph.D.  (mailto: Darrell.Ricke@ll.mit.edu)
# Copyright:: 	Copyright (c) 2014 MIT Lincoln Laboratory
# License::   	GNU GPL license  (http://www.gnu.org/licenses/gpl.html)
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

################################################################################
# This class sequence words derived from a sequence.
class Tuples
         
################################################################################

# common words
attr_accessor :common_words

# alignment inserts
attr_accessor :inserts

# sequence
attr_accessor :sequence

# number of residues in current word
attr_accessor :word_size

# array of words derived from the fasta sequence
attr_accessor :words

# positions of the words in the fasta sequence
attr_accessor :words_positions
  
         
################################################################################
def initialize
  @common_words = []
  @inserts = {}
  @sequence = ""
  @word_size = 3
  @words = []
  @words_positions = {} 
end  # method initialize


################################################################################
# This method determines the common words between two sequences.
def calc_common( sequence2_words, pos2 )
  @common_words = @words & sequence2_words
end  # method calc_common


################################################################################
# This method determines the common words between two sequences.
def calculate_common( sequence2_words, pos2 )
  common_words = @words & sequence2_words
  uniq_words = unique_common( common_words, sequence2_words )
  @common_words = ordered_common( uniq_words, sequence2_words, pos2 )
end  # method calculate_common


################################################################################
# This method selects the ordered common words.
def ordered_common( common, sequence2_words, pos2 )
  ordered = []
  previous1 = previous2 = 0
  return ordered if (@words_positions.nil?) || (@words_positions[ common[ 0 ] ].nil?)
  index1 = @words_positions[ common[ 0 ] ][ 0 ]
  index2 = pos2[ common[ 0 ] ][ 0 ]
  for i in 0...common.size do

    # Determine the positions of the next word.
    if ( i + 1 < common.size )
      following1 = @words_positions[ common[ i+1 ] ][ 0 ]
    else
      following1 = @words.size + @word_size
    end  # if
    if ( i + 1 < common.size )
      following2 = pos2[ common[ i+1 ] ][ 0 ]
    else
      following2 = sequence2_words.size + @word_size
    end  # if

    jump1 = index1 - previous1
    jump2 = index2 - previous2
    delta1 = following1 - index1
    delta2 = following2 - index2

    # puts "#{common[i]}: index1: #{index1}, index2: #{index2}, previous1: #{previous1}, previous2: #{previous2}, following1: #{following1}, following2: #{following2}, delta1: #{delta1}, delta2: #{delta2}"
    ordered << common[i] if ( ( index1 > previous1 ) && ( index1 < following1 ) && ( index2 > previous2 ) && ( index2 < following2 ) && ( delta1 <= 20) && ( delta2 <= 20 ) && ( delta1 > 0 ) && ( delta2 > 0 ) && ( jump1 <= 20 ) && ( jump2 <= 20 ) && ( jump1 > 0 ) && ( jump2 > 0 ) )

    previous1 = index1
    previous2 = index2
    index1 = following1
    index2 = following2
  end  # for

  return ordered
end  # ordered_common


################################################################################
# Select the unique common words.
def unique_common( common, words2 )
  # Determine the unique common words.
  uniq_common = []
  common.each do |word|
    uniq_common << word if ( @words.index( word ) == @words.rindex( word ) ) &&
                           ( words2.index( word ) == words2.rindex( word ) )
  end  # do
  
  return uniq_common
end  # unique_common


################################################################################
# This method calculate the alignment blocks between two sequences.
def calculate_positions
  # Convert the common words and positions into ordered positions.
  positions = []
  @common_words.each do |common_word|
    positions << @words_positions[ common_word ]
  end  # do
   
  @common_positions = drop_gaps( positions.flatten.sort )  
  
  # puts " positions: #{@common_positions}"
  
  return @common_positions
end  # method calculate_positions

         
################################################################################
# This method calculates the words from the sequence.
def calculate_words( seq )
  # Assert: sequence data
  return if seq.nil?
  return if @word_size < 1
  return if (seq.length < @word_size)
  @sequence = seq
 
  # Split the fasta sequence into words
  @words = []
  @word_positions = {}
  for i in 0...(seq.length - @word_size + 1)
    word = seq[ i..(i + @word_size - 1)]
    @words << word
    
    # Record the position for each word - track collisions
    if @words_positions[ word ].nil?
      @words_positions[ word ] = [i + 1]
    else
      @words_positions[ word ] << i+1
    end  # if
  end  # for

  # puts "words: #{@words}"
end  # method calculate_words


################################################################################
def align_words( seq1, seq2, pos2, name )
  # Align this sequence using the common words.
  align = {}
  @common_words.each do |cw|
    if ( @words_positions[ cw ].length == 1 ) && ( pos2[ cw ].length == 1 )
      # puts "cw: " + cw + ", pos: " + @words_positions[cw] )

      # Copy the common word to the alignment.
      pos1 = @words_positions[ cw ][ 0 ]
      for i in 0...@word_size do
        align[ pos1+i ] = cw[i]
      end  # for
    end  # if
  end  # do

  # Fill in the alignment gaps.
  align = fill_gaps( align, seq1, seq2, pos2, name )

  return align
end  # align_words

         
################################################################################
def fill_gaps( align, seq1, seq2, pos2, name )
    # Align the start of the MSA.

    start1 = start2 = 1
    cw_1 = @common_words[0]
    return align if @words_positions[ cw_1 ].nil?
    end1 = @words_positions[ cw_1 ][ 0 ] 
    end2 = pos2[ cw_1 ][ 0] 
    align = left_align( align, seq1, start1, end1, seq2, start2, end2, name ) if ( end1 > start1 ) || ( end2 > start2 )

    # Align the internal gaps.
    for i in 1...@common_words.length do
      cw_2 = @common_words[i]
      if ( @words_positions[ cw_2 ].length == 1 ) && ( pos2[ cw_2 ].length == 1 )
        start1 = @words_positions[ cw_1 ][ 0 ] + @word_size
        start2 = pos2[ cw_1 ][ 0 ] + @word_size
        end1 = @words_positions[ cw_2 ][ 0 ] - 1
        end2 = pos2[ cw_2 ][ 0 ] - 1
        # puts( "fill_gaps: #{start1}-#{end1} X #{start2}-#{end2}" ) if ( end1 > start1 ) && ( end2 > start2 )
        align = sub_align( align, seq1, start1, end1, seq2, start2, end2, name ) if ( end1 >= start1 ) && ( end2 >= start2 )
        cw_1 = cw_2  # reset for next loop iteration
      end  # if
    end  # for

    # Align the end of the MSA.
    start1 = @words_positions[ cw_1 ][ 0 ] + @word_size 
    start2 = pos2[ cw_1 ][ 0 ] + @word_size
    end1 = @sequence.length
    end2 = seq2.length
    align = right_align( align, seq1, start1, end1, seq2, start2, end2, name ) if ( end1 >= start1 ) || ( end2 >= start2 )

    return align
end  # fill_gaps

         
################################################################################
def left_align( align, seq1, start1, end1, seq2, start2, end2, name )
  # puts( "left_align: #{start1}-#{end1} X #{start2}-#{end2}" )

  len2 = end2 - start2 + 1
  s1 = end1 - len2 + 1

  for i in 0...len2 do
    if ( s1+i-1 < 0 )
      @inserts[0] = {} if @inserts[0].nil?
      @inserts[0][name] = "" if @inserts[0][name].nil?
      @inserts[0][name] = seq2[start2+i-1].downcase + @inserts[0][name]
    else
      if ( seq2[start2+i-1] != seq1[start1+i-1] )
        align[s1+i] = seq2[start2+i-1].downcase
      else
        align[s1+i] = seq2[start2+i-1]
      end  # if
    end  # if
  end  # for

  return align
end  # left_align

         
################################################################################
def right_align( align, seq1, start1, end1, seq2, start2, end2, name )
  # puts( "right_align: #{start1}-#{end1} X #{start2}-#{end2}" )

  len2 = end2 - start2 + 1

  # Check endcase of when sequence is longer than first sequence.
  for i in 0...len2 do
    # if ( start1+i-1 < seq1.size )
      if ( seq2[start2+i-1] != seq1[start1+i-1] )
        align[start1+i] = seq2[start2+i-1].downcase
      else
        align[start1+i] = seq2[start2+i-1]
      end  # if
    # end  # if
  end  # for

  return align
end  # right_align

         
################################################################################
def sub_align( align, seq1, start1, end1, seq2, start2, end2, name )
  return align if ( start1 > end1 ) || ( start2 > end2 )
  # return align if ( start1 <= end1 )  # insert for other sequence.

  # puts( "sub_align: #{start1}-#{end1} X #{start2}-#{end2}" )

  len1 = end1 - start1 + 1
  len2 = end2 - start2 + 1
  if ( len1 == len2 )
    for i in 0...len2 do
      if (! seq2[start2+i-1].nil?) && (! seq1[start1+i-1].nil?)
        if ( seq2[start2+i-1] != seq1[start1+i-1] )
          align[start1+i] = seq2[start2+i-1].downcase
        else
          align[start1+i] = seq2[start2+i-1]
        end  # if
        # puts( "  #{start1+i}:#{start2+i} <- #{align[start1+i]}" )
      # else
      #   puts( "  #{start2+i-1} is nil" )
      end  # if
    end  # for
  else
    slider = SlideAlign.new
    align1, align2 = slider.align( seq1[(start1-1)..(end1-1)], seq2[(start2-1)..(end2-1)] )
    insert1 = start1
    for i in 0...align1.size do
      if ( align1[i] == align2[i] )
        align[insert1] = align2[i]
      else
        align[insert1] = align2[i].downcase
      end  # if

      if ( align1[i] != "." )
        insert1 += 1 
      else
        @inserts[insert1] = {} if @inserts[insert1].nil?
        @inserts[insert1][name] = "" if @inserts[insert1][name].nil?
        @inserts[insert1][name] << align2[i].downcase
        # puts "--> insert: #{insert1} #{@inserts[insert1][name]}"
      end  # if
    end  # for
  end  # if

  return align
end  # sub_align

         
################################################################################
def show_common_words( pos2 )
  puts "common words: #{@common_words}"
  puts "order:"
  @common_words.each do |cw|
    puts "#{@words_positions[ cw ][0]} X #{pos2[cw][0]} : #{cw}"
  end  # do
end  # method show_common_words
  
         
################################################################################

end  # class

         
################################################################################
# class testing method.
def test_sequence_words
  app = Tuples.new
  fasta = FastaSequence.new( 'Test', 'No desc', "ACGTAAAGGGACGTGGAC", 'AA' )
  app.calculate_words( fasta.sequence_data )
  puts "words: #{app.words}"
  puts "positions: #{app.words_positions}"
  seq2_words = ["CGA", "GAA", "AAA", "AAA", "AAG", "AGG", "GGG", "GGT", "GTC", "TCG", "CGT", "GTG", "TGG", "GGA"]
  app.calculate_common( seq2_words )
  app.show_common_words
end  # method test_sequence_words

         
################################################################################
# test_sequence_words()
