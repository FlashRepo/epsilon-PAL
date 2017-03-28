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

function [ output_vector ] = append( input_vector, element )
%This function appends a value to a column vector
%It assumes that if the value of input_vector is -1 then it is not
%initialized.

    if (input_vector == -1)
        output_vector = [element];
    else
        output_vector = [input_vector;element];
    end
end

