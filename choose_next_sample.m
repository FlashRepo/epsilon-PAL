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

function [untouched_set,pop_sampled,pop_predicted,state,conf_dup] = choose_next_sample(untouched_set,pop_sampled,pop_predicted,conf,state,gp_conf) 

    if (pop_sampled.num_entries == 0)
        %init trainig set 

        for tmp_iter = 1:conf.length_training_start
            index_sel=randi([1,untouched_set.num_entries],1,1);

            if conf.test_mode == 0
                [obj1,obj2] = eval_func(features_in,conf);
                entry_tmp = [untouched_set.get_entries(index_sel),obj1,obj2];
            else
                entry_tmp = untouched_set.get_entries(index_sel);
            end
            pop_sampled = pop_sampled.add_entry(entry_tmp);
            untouched_set = untouched_set.remove_entries(index_sel);
        end

        if (pop_predicted.num_entries == 0)

            num_new_pred=untouched_set.num_entries;
            entry_tmp = [untouched_set.get_entries(1:num_new_pred),zeros(num_new_pred,2),zeros(num_new_pred,2),zeros(num_new_pred,2),zeros(num_new_pred,2),zeros(num_new_pred,1)];
            pop_predicted = pop_predicted.add_entry(entry_tmp);
            untouched_set = untouched_set.remove_entries(1:num_new_pred); 

        end

    else

        %pre_no_class_var = pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,1) + pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,2);
        %sampling_index_tmp = pick_sampling_max_variance(pre_no_class_var);
     
        %pop_predicted = pop_predicted.set_pareto(sampling_index_tmp,1);

        found_unclassified = 0;
        
            
        while (found_unclassified==0)
            pre_no_class_var = pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,1) + pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,2);
            pre_no_class_var = pre_no_class_var.*(~pop_predicted.get_pareto(:));
            check_index = pick_sampling_max_variance(pre_no_class_var); 
            %check_index
            if check_pareto(check_index,pop_sampled,pop_predicted,conf)==1
                pop_predicted = pop_predicted.set_pareto(check_index,1);
                %check if anything can be discarded with it
                [state,pop_predicted] = discard(pop_sampled,pop_predicted,conf,state);
                %discarded_num_in_sampling = tmp1 - pop_predicted.num_entries                            
            else
                found_unclassified = 1;
            end
            %pop_predicted.get_pareto(:)
            if (sum((pop_predicted.get_pareto(:)))==pop_predicted.num_entries)
                break
            end

        end


        if (pop_predicted.get_pareto(:)==ones(pop_predicted.num_entries,1))
            state.force_end = 1;
        else
            %recalculate index with max variance - in case there were
            %some points removed from predicted
            pre_no_class_var = pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,1) + pop_predicted.get_rt_sigma(1:pop_predicted.num_entries,2);
            sampling_index_tmp = pick_sampling_max_variance(pre_no_class_var);

            cell_out = pop_predicted.remove_entry(sampling_index_tmp);
            rand_sample = ceil((11).*rand(1,1));
            if rand_sample == 1
                %disp('random sample >>>>')
                sampling_index_tmp = ceil((pop_predicted.num_entries).*rand(1,1));
            end
            
            pop_predicted = cell_out{1};
            sel_entry = cell_out{2};

            if conf.test_mode == 0
                [obj1,obj2] = eval_func(features_in,conf);
                sel_entry = [sel_entry,obj1,obj2];
            end
            
            pop_sampled = pop_sampled.add_entry(sel_entry);
            
        end
                       
    end

    %disp('end choose next sample')

    %{pop_sampled,pop_predicted,not_p_out,sampled_projections};
    
end
