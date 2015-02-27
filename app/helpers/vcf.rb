
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
# This class provides an object model for a VCF variant.
class Vcf

# the current line 
attr_accessor :line 
# line tokens
attr_accessor :parts


attr_accessor :accession
attr_accessor :alt
attr_accessor :filter
attr_accessor :format
attr_accessor :id
attr_accessor :info
attr_accessor :position
attr_accessor :qual
attr_accessor :ref
attr_accessor :sample

attr_accessor :eff
attr_accessor :info_map
attr_accessor :sample_map

###############################################################################
# 
def initialize( line )
  @line = line			# Current text line
  @parts = @line.split( "\t" )
  @accession = @parts[0]
  @position  = @parts[1]
  @id        = @parts[2]
  @ref       = @parts[3]
  @alt       = @parts[4]
  @qual      = @parts[5]
  @filter    = @parts[6]
  @info      = @parts[7]
  @format    = @parts[8]
  @sample    = @parts[9]
  for i in 9...@parts.size do
    @sample = @parts[i] if @parts[i].size > 1
  end  # for
  
  @eff = []
  @info_map = {}
  @sample_map = {}
end  # method initialize
  
###############################################################################
def parse
  # Parse the info data.
  tokens = info.split( ";" )
  tokens.each do |token|
    if token.include?( "=" )
      pieces = token.split( "=" )
      @info_map[ pieces[0] ] = pieces[1]
    else
      @info_map[ token ] = true
    end  # if
  end  # do
  
  # Parse the sample map.
  names = format.split( ":" )
  tokens = sample.split( ":" )
  for i in 0...names.size do
    @sample_map[ names[i] ] = tokens[i]
  end  # for
  
  # Parse the EFF details.
  if ! @info_map[ "EFF" ].nil?
    @eff = @info_map[ "EFF" ].split( "," )
  end  # if
  
end  # parse
  
###############################################################################
def snap
  puts "#{@accession}\t#{@position}\t#{@ref}\t#{@alt}\t#{@qual}\n"
  print "  --:"
  @info_map.each do |key, value|
    print "#{key}:#{value} " if (key != "EFF")
  end  # do
  print "\n"
  @eff.each do |eff|
    details = eff.delete(")").gsub( "(", "|" ).split( "|" )
    str = details.join( ":" )
    puts "  --#{str}"
  end  # do
  puts
end  # snap

###############################################################################
def to_string
  return @line
end  # to_string

###############################################################################


###############################################################################
end  # class Vcf


