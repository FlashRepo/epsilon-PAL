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

function pareto_sets = get_pareto_sets(obj1, obj2)

    pareto_01list = get_pareto_01list(obj1, obj2);
    obj1_list = -1;
    obj2_list = -1;
        
    for i=1:length(pareto_01list)       
    	if ((pareto_01list(i)==1))
            obj1_list = append(obj1_list,obj1(i));
            obj2_list = append(obj2_list,obj2(i));
        end
    end
        
    [obj1_list_pareto,obj2_list_pareto,tmp_rest_list] = order_pareto(obj1_list,obj2_list,zeros(length(pareto_01list),1));
        
    pareto_sets{1} = obj1_list_pareto;
    pareto_sets{2} = obj2_list_pareto;
    disp(pareto_sets);

end