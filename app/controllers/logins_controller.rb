
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

############################################################################
class LoginsController < ApplicationController

  skip_before_filter :authenticate
  
#############################################################################
  def clear_sessions
    session[:individual_id] = nil
    session[:guid1] = nil
    session[:guid2] = nil
    session[:data_entry_id] = nil
  end  # clear_sessions
  
#############################################################################
  # GET /logins
  # GET /logins.xml
  def index
    clear_sessions
  end  # index  
  
  #############################################################################
  # GET /change_pw
  def change_pw
    puts "******** LoginsController change_pw called"
  end  # change_pw

#############################################################################
  def show
    redirect_to(logins_url)
  end  # show
  
#############################################################################
  def logout
    clear_sessions
    redirect_to(logins_url)
  end  # logout

#############################################################################
  def verify    
    name = params[:name]
    @individual = Individual.find_by_data_entry_id(name)
    if (@individual != nil)
      # Verify the password
      if @individual.password_hash.blank?
        @individual.password = params[:password]
        @individual.save
      else
        # Validate the given password
        if !@individual.verify_password(params[:password])
          flash[:notice] = "Invalid code name/password combination"
          redirect_to(logins_url)
          return
        end  # if
      end  # if
      
      session[:individual_id] = @individual.id
      session[:guid1] = @individual.guid1
      session[:guid2] = @individual.guid2
      session[:data_entry_id] = @individual.data_entry_id
    
      redirect_to(activities_url)      
      return
    else
      flash[:notice] = "Unknown code name/password combination."
    end  # if
    
    #not found
    flash[:notice] = "Code name '#{name}' was not found."
    redirect_to(logins_url)
  end  # verify
  
  #############################################################################
  def verify_change  
    # puts ">>>>> verify_change called"  
    @individual = Individual.find(session[:individual_id])
    if (@individual != nil)
      # puts "***** verify_change found individual ****"
      
      # Verify the password
      if @individual.password_hash.blank?
        @individual.password = params[:new_password]
        @individual.save
      else
        # Validate the given password
        # puts "****** password: #{params[:password]}"
        if !@individual.verify_password(params[:password])
          flash[:notice] = "Invalid old password"
          redirect_to action: 'change_pw', alert: 'Invalid old password'
          return
        else
          # puts ">>>>> password changed"
          @individual.password = params[:new_password]
          @individual.save
        end  # if
      end  # if
      
      redirect_to(sleeps_url)      
      return
      else
      flash[:notice] = "Unknown code name/password combination."
    end  # if
    
    #not found
    flash[:notice] = "Individual not found"
    redirect_to(logins_url)
  end  # verify_change
  
#############################################################################
  def reset_password
    @individual = Individual.find(params[:id])
    if @individual.password_hash.blank?
      flash[:notice] = "Individual's password is blank"
      redirect_to(individuals_path)
    else
      @individual.password_hash = ""
      @individual.save
      flash[:notice] = "Password was successfuly reset"
      redirect_to(individuals_path)
    end # If
  end # reset_password

#############################################################################
end  # class LoginsController
