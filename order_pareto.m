% PAL (Pareto Active Learning) Algorithm 
%
% Copyright (c) 2013 ETH Zurich
% 
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function [ obj1_ordered,obj2_ordered, rest_ordered ] = order_pareto( obj1,obj2,rest )
%ordering a set of pareto points with respect to the obj1 axis 

    obj1_ordered = obj1;
    obj2_ordered = obj2;
    rest_ordered = rest;
    for index_1=1:length(obj1_ordered)
            for index_2=1:(length(obj1_ordered)-1)
                    if (obj1_ordered(index_2)>obj1_ordered(index_2+1))
                            temp_value_x = obj1_ordered(index_2);
                            temp_value_y = obj2_ordered(index_2);
                            temp_value_rest = rest_ordered(index_2);
                            obj1_ordered(index_2) = obj1_ordered(index_2+1);
                            obj2_ordered(index_2) = obj2_ordered(index_2+1);
                            rest_ordered(index_2,:) = rest_ordered(index_2+1,:);
                            obj1_ordered(index_2+1) = temp_value_x;
                            obj2_ordered(index_2+1) = temp_value_y;
                            rest_ordered(index_2+1,:) = temp_value_rest;
                    end
            end
    end

end

