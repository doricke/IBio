class Statistics

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

################################################################################
def self.standard_deviation(x, x_mean)
    sum = x.inject(0){|accum, i| accum +(i-x_mean)**2 }
    variance = sum/(x.length - 1).to_f
    return Math.sqrt(variance)
end  # standard_deviation

################################################################################
#naive program http://blog.chrislowis.co.uk/2008/11/24/ruby-gsl-pearson.html
def self.pearson(x,y)
    n=x.length
    
    sumx=x.inject(0) {|r,i| r + i}
    sumy=y.inject(0) {|r,i| r + i}
    
    sumx_sq=x.inject(0) {|r,i| r + i**2}
    sumy_sq=y.inject(0) {|r,i| r + i**2}
    
    prods=[]; x.each_with_index{|this_x,i| prods << this_x*y[i]}
    p_sum=prods.inject(0){|r,i| r + i}
    
    # Calculate Pearson score
    num=p_sum-(sumx*sumy/n)
    den=((sumx_sq-(sumx**2)/n)*(sumy_sq-(sumy**2)/n))**0.5
    return 0 if den.zero?
    return num/den
end  # pearson

################################################################################
end  # class

