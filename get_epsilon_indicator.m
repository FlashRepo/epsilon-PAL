% PAL (Pareto Active Learning) Algorithm 
%
% Copyright (c) 2014 ETH Zurich
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

function [epsilon_perc_obj1,epsilon_perc_obj2,avg_min_obj1,avg_min_obj2]  = get_epsilon_indicator(real_pareto_set,pareto_01list,real_obj1,real_obj2,range_obj1,range_obj2)

real_pareto_obj1 = real_pareto_set{1};
real_pareto_obj2 = real_pareto_set{2};

max_epsilon = 0;

predicted_pareto_obj1 = -1;
predicted_pareto_obj2 = -1;

for i=1:length(pareto_01list)
   if ((pareto_01list(i)==1))
       predicted_pareto_obj1 = append(predicted_pareto_obj1,real_obj1(i));
       predicted_pareto_obj2 = append(predicted_pareto_obj2,real_obj2(i));
   end
end

min_list=-1;

for i=1:length(real_pareto_obj1)

    for j=1:length(predicted_pareto_obj1)
        diff_obj1 = (predicted_pareto_obj1(j) - real_pareto_obj1(i))*100/range_obj1;
        diff_obj2 = (real_pareto_obj2(i) - predicted_pareto_obj2(j))*100/range_obj2;

        if diff_obj1<0
            diff_obj1 = 0;
        end
        if diff_obj2<0
            diff_obj2 = 0;
        end
        
        if diff_obj1>diff_obj2
            max_diff = diff_obj1;
        else
            max_diff = diff_obj2;
        end
        if j==1
            min_epsilon = max_diff;
        else
            if max_diff < min_epsilon
                min_epsilon = max_diff;
            end
        end
        
    end
    
    min_list = append(min_list,min_epsilon);
    if min_epsilon>max_epsilon
        max_epsilon = min_epsilon;

    end

end
% max_epsilon=max_epsilon
%min_list=min_list
% avg_min = mean(min_list)
% 
% pause
avg_min_obj1 = mean(min_list);
avg_min_obj2 = mean(min_list);

epsilon_perc_obj1 = max_epsilon;
epsilon_perc_obj2 = max_epsilon;

end

