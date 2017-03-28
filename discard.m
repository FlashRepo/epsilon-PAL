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

function [state,pop_predicted] = discard(pop_sampled,pop_predicted,conf,state)
%disp('discard')
%7pop_predicted_size = pop_predicted.num_entries
    range_obj1 = conf.train_data_range_obj1;
    range_obj2 = conf.train_data_range_obj2;
    epsilon = conf.epsilon_classification;
    
    %make a list of pareto optimistic
    u_rt_obj1 = [pop_sampled.get_real_obj(:,1);pop_predicted.get_rt_mu(:,1)];
    u_rt_obj2 = [pop_sampled.get_real_obj(:,2);pop_predicted.get_rt_mu(:,2)];
    s_rt_obj1 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(:,1)];
    s_rt_obj2 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(:,2)];

    obj1_pessimistic = (u_rt_obj1-(epsilon*range_obj1)) + s_rt_obj1;
    obj2_pessimistic = (u_rt_obj2+(epsilon*range_obj2)) - s_rt_obj2;
    obj1_optimistic = (u_rt_obj1+(epsilon*range_obj1)) - s_rt_obj1;
    obj2_optimistic = (u_rt_obj2-(epsilon*range_obj2)) + s_rt_obj2;

    [pareto_pess_obj1,pareto_pess_obj2, pess_pareto_01list] = get_pareto_pairs(obj1_pessimistic,obj2_pessimistic);
  
    np_01list = zeros(length(u_rt_obj1),1);

    %compare with sampled points; check if any point is dominated by a
    %sampled point or pareto points
    temp_01list = [ones(pop_sampled.num_entries,1);pop_predicted.get_pareto(:)];
    
    obj1_optimistic_tmp = obj1_optimistic.*(~temp_01list);
    obj2_optimistic_tmp = obj2_optimistic.*(~temp_01list);

    obj1_pessimistic_tmp = obj1_pessimistic.*(temp_01list);
    obj2_pessimistic_tmp = obj2_pessimistic.*(temp_01list);

    obj1 = obj1_pessimistic_tmp+obj1_optimistic_tmp;
    obj2 = obj2_optimistic_tmp+obj2_pessimistic_tmp;

        
    [sorted_obj1,sorted_obj1_ind]=sort(obj1);

    max_obj2=0;

    for i=1:length(sorted_obj1_ind)

        ind = sorted_obj1_ind(i);

        if (temp_01list(ind)==1)
            if obj2(ind)>max_obj2
              max_obj2 = obj2(ind);
            end
        else      
            if max_obj2 >= obj2(ind)
                np_01list(ind) = 1;
            end
        end
    end    

    %compare with pareto pessimistic
    obj1_optimistic_tmp = obj1_optimistic.*(~pess_pareto_01list);
    obj2_optimistic_tmp = obj2_optimistic.*(~pess_pareto_01list);

    obj1_pessimistic_tmp = obj1_pessimistic.*(pess_pareto_01list);
    obj2_pessimistic_tmp = obj2_pessimistic.*(pess_pareto_01list);

    obj1 = obj1_pessimistic_tmp+obj1_optimistic_tmp;
    obj2 = obj2_optimistic_tmp+obj2_pessimistic_tmp;

    [sorted_obj1,sorted_obj1_ind]=sort(obj1);

    %check second dimension
    max_obj2=0;
    for i=1:length(sorted_obj1_ind)

        ind = sorted_obj1_ind(i);
        if np_01list(ind) == 1
            continue
        end
        if (pess_pareto_01list(ind)==1)
              max_obj2 = obj2(ind);
        else    
            
            if ((temp_01list(ind)==0)&&(max_obj2 >= obj2(ind)))
                np_01list(ind) = 1;
            end
        end
    end
    
    np_index_predicted = find((np_01list(pop_sampled.num_entries+1:length(np_01list))==1));
    pop_predicted = pop_predicted.remove_entries(np_index_predicted);
    

end

