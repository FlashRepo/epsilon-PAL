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

function is_pareto = check_pareto(i,pop_sampled,pop_predicted,conf)
    range_obj1 = conf.train_data_range_obj1;
    range_obj2 = conf.train_data_range_obj2;
    epsilon = conf.epsilon_classification;
    
    %i is an index of pop_predicted
    %remove duplicates and not-pareto from pop_sampled, also remove i entry

    obj1_pessimistic_i = (pop_predicted.get_rt_mu(i,1)-(epsilon*range_obj1)) + pop_predicted.get_rt_sigma(i,1);
    obj2_pessimistic_i = (pop_predicted.get_rt_mu(i,2)+(epsilon*range_obj2)) - pop_predicted.get_rt_sigma(i,2);
           
    u_rt_obj1 = [pop_sampled.get_real_obj(1:pop_sampled.num_entries,1);pop_predicted.get_rt_mu(1:pop_predicted.num_entries,1)];
    u_rt_obj2 = [pop_sampled.get_real_obj(1:pop_sampled.num_entries,2);pop_predicted.get_rt_mu(1:pop_predicted.num_entries,2)];
    s_rt_obj1 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,1)];
    s_rt_obj2 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,2)];

    obj1_optimistic = (u_rt_obj1+(epsilon*range_obj1)) - s_rt_obj1;
    obj2_optimistic = (u_rt_obj2-(epsilon*range_obj2)) + s_rt_obj2;

	a_p_i = kron(obj1_pessimistic_i,ones(length(u_rt_obj1),1));
	t_p_i = kron(obj2_pessimistic_i,ones(length(u_rt_obj1),1));

	a2 = obj1_optimistic < a_p_i;
	t2 = obj2_optimistic > t_p_i;

	p = a2 & t2;
	
	sum_pareto = sum(p);
	is_pareto = sum_pareto ==0;


end
 
