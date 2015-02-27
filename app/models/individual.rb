
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

class Individual < ActiveRecord::Base
    
  validates_presence_of :code_name
  validates :code_name, uniqueness: true
  
#############################################################################
  def password=(pwd)
    create_new_salt
    self.password_hash = encrypted_password(pwd, self.password_salt)
    self.password_hash = self.password_hash[0...64] if (self.password_hash.size > 64)
  end  # method password=
    
#############################################################################
  def authenticate(code_name, password)
    individual = self.find_by_code_name(code_name)
    if individual
      expected_password = encrypted_password(password, individual.password_salt)
      individual = nil if individual.password_hash != expected_password
    end  # if
    individual
  end  # method authenticate
    
#############################################################################
  def verify_password(password)
    create_new_salt if self.password_salt.nil?
    expected_password = encrypted_password(password, self.password_salt)
    return false if self.password_hash != expected_password
    return true
  end  # method verify_password
    
#############################################################################
private
    
#############################################################################
  def create_new_salt
    self.password_salt = self.object_id.to_s + rand.to_s
    self.password_salt = self.password_salt[0...64] if ( self.password_salt.size > 64 )
  end  # method create_new_salt
    
#############################################################################
  def encrypted_password(password, salt)
    string_to_hash = password + "pwp3r" + salt
    new_ep = Digest::SHA1.hexdigest(string_to_hash)
    new_ep = new_ep[0...64] if (new_ep.length > 64)
    new_ep
  end  # method encrypted_password

end  # class
