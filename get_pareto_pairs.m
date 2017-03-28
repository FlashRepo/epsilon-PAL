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

function [pareto_obj1,pareto_obj2,pareto_01list]  = get_pareto_pairs(obj1, obj2)

pareto_01list = zeros(length(obj1),1);
max_thrput = 0;
%sort in one dimension
[sorted_obj1,sorted_obj1_ind]=sort(obj1);

%check second dimension
pareto_obj1 = [];
pareto_obj2 = [];

pareto_previous=0;
pareto_previous_ind=0;
pareto_previous_obj1=0;
for i=1:length(sorted_obj1_ind)
   ind = sorted_obj1_ind(i);

   if (pareto_previous==1) 
 

       if (pareto_previous_obj1 ~= obj1(ind))
            pareto_01list(pareto_previous_ind) = 1;
           pareto_obj1 = append(pareto_obj1,obj1(pareto_previous_ind));
           pareto_obj2 = append(pareto_obj2,obj2(pareto_previous_ind));

            pareto_previous=0;
           if max_thrput < obj2(ind) 
               max_thrput = obj2(ind);
               pareto_previous=1;
               pareto_previous_ind=ind;
               pareto_previous_obj1 = obj1(ind);
           end

       else
            if max_thrput < obj2(ind) 
               max_thrput = obj2(ind);
               pareto_previous_ind=ind;
            end
        end

   else
       if max_thrput < obj2(ind) 
           max_thrput = obj2(ind);
           pareto_previous=1;
           pareto_previous_ind=ind;
           pareto_previous_obj1 = obj1(ind);
       end
   end
    %pause
end
if pareto_previous==1
    pareto_01list(pareto_previous_ind) = 1;
       pareto_obj1 = append(pareto_obj1,obj1(pareto_previous_ind));
       pareto_obj2 = append(pareto_obj2,obj2(pareto_previous_ind));
end


end






