    
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
class SlideAlign

attr_accessor :align1       # aligned sequence 1

attr_accessor :align2       # aligned sequence 2
    
attr_accessor :matches      # number of base matches

attr_accessor :mismatches   # number of base mismatches
    
attr_accessor :seq1         # subsequence 1
    
attr_accessor :seq2         # subsequence 2
      
         
################################################################################
def initialize
  @align1  = ""
  @align2  = ""
  @matches = 0
  @mismatches = 0  
  @seq1    = ""
  @seq2    = ""
end  # initialize
      
         
################################################################################
def align( sub1, sub2 )
  @align1 = ""
  @align2 = ""
  @seq1 = sub1
  @seq2 = sub2
  @matches = 0
  @mismatches = 0
  @mismatches = sub1.size if ! sub1.nil?
  
  # Assert: subsequences supplied.
  return if ( sub1.nil? && sub2.nil? )
  if sub1.nil?
    @align1 = " ".rjust( sub2.size ).gsub( " ", "." )  # Add the gap
    @align2 = sub2
    return
  end  # if
  if sub2.nil?
    @align1 = sub1
    @align2 = " ".rjust( sub1.size ).gsub( " ", "." )
    return
  end  # if
  
  if sub1.size == sub2.size
    @align1 = sub1
    @align2 = sub2
    count_matches
    return sub1, sub2
  end  # if
  
  if sub1.size < sub2.size
    @align1 = slide( sub1, sub2 )
    @align2 = sub2
  else
    @align1 = sub1
    @align2 = slide( sub2, sub1 )
  end  # if
  
  # puts "SlideAlign.1 #{@align1}"
  # puts "SlideAlign.2 #{@align2}"
  return @align1, @align2
end  # method align

         
################################################################################
# Count the sequence matches between the aligned sequences.
def count_matches
  match = 0
  mismatch = 0
  for i in 0...@align1.length do
    if @align1[ i ] == @align2[ i ]
      match += 1
    else
      mismatch += 1
    end  # if
  end  # for
  
  @matches = match
  @mismatches = mismatch
end  # method count_matches

         
################################################################################
# Slide alignment method; length of sub1 < length of sub2
def slide( sub1, sub2 )
  # Determine the optimal alignment.
  best_start = 0
  best_count = 0
  gap_size = sub2.size - sub1.size
  
  for gap_start in 0..sub1.size do
    count = 0
    for i in 0...sub1.size do
      if i < gap_start
        count += 1 if sub1[ i ] == sub2[ i ]
      else
        count += 1 if sub1[ i ] == sub2[ i + gap_size ]
      end  # if
    end  # for
   
    # puts "gap_start: #{gap_start}, count: #{count}, best_count: #{best_count}, gap_size: #{gap_size}"
     
    if ( count > best_count )
      best_count = count
      best_start = gap_start
    end  # if
  end  # for
   
  # puts "slide: best_start: #{best_start}, best_count: #{best_count}, gap_size: #{gap_size}"
    
  align1 = ""
  align1 = sub1[ 0...best_start ]  if gap_start > 0  
  align1 << " ".rjust( gap_size ).gsub( " ", "." )  # Add the gap
  align1 << sub1[ best_start...sub1.size ]
  
  @matches = best_count
  @mismatches = sub2.size - best_count
  
  # puts "slide: align1:#{align1}"
  return align1
end  # method slide

         
################################################################################
# Slide alignment method; length of sub1 < length of sub2
def slide1( sub1, sub2 )
  # Determine the optimal alignment.
  best_start = 0
  best_count = 0
  for i in 0...(sub2.size - sub1.size) do
    count = 0
    for j in 0...sub1.size do
      count += 1 if sub1[ j ] == sub2[ i + j ]
    end  # for
    
    if ( count > best_count )
      best_count = count
      best_start = i
    end  # if
  end  # for
    
    @align1 << " ".rjust( gaps ).gsub( " ", "." ) if @seq1.size < @seq2.size
  
end  # method slide1

         
################################################################################

end  # class SlideAlign
