
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
# This class contains utility functions for working with string text.
class TextTools


################################################################################
# This method extracts the next token from the line.
def self.next_token( line, start )
  return "", line.length if ( start + 1 >= line.length )

  # Check for a quoted string.
  start += 1 if (line[ start, 1 ] == ',')

  if ( line [ start, 1 ] == '"' ) 
    index = line.index( '"', start + 1 )
    if ( index.nil? )
      return line.slice( (start + 1)...line.length ).strip, line.length
    end  # if 
    return line.slice( (start + 1)...index ).strip, index + 1 
  end  # if

  # Grab the next token.
  index = line.index( ',', start )
  if ( index.nil? )
    return line.slice( start..line.length ).strip, line.length 
  end  # if

  # Check for no token - just two delimiters.
  return "", index if ( start == index )

  return line.slice( start...index ).strip, index
end  # method next_token


################################################################################
def self.csv_split( line )
  tokens = []
  return tokens if ( line.nil? )

  tokens_index = 0
  token_start = 0
  next_index = 0

  # Loop through all of the delimiters.
  while ( next_index < line.length )
    tokens [ tokens_index ], next_index = next_token( line, token_start )
    tokens_index += 1
    token_start = next_index
  end  # while

  puts "TextTools:csv_split #{tokens.join('|')}"
  return tokens
end  # method csv_split


################################################################################

end  # class TextTools

