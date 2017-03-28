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

function [pop_predicted,gp_conf] = update_predictions(pop_sampled,pop_predicted,gp_conf,conf,state)

    features_train = pop_sampled.get_features(1:pop_sampled.num_entries);
    features_test = pop_predicted.get_features(1:pop_predicted.num_entries);
    response_train_obj1 = pop_sampled.get_real_obj(1:pop_sampled.num_entries,1);
    response_train_obj2 = pop_sampled.get_real_obj(1:pop_sampled.num_entries,2); 

    %GP regression
    if ((state.iter_train==1) || mod(state.iter_train,conf.gap_hyp_update)==0)
            %disp('find hyperparams........')
            
            gp_conf.hyp_obj1  = gp_find_hp(features_train, response_train_obj1,gp_conf);
            gp_conf.hyp_obj2 = gp_find_hp(features_train, response_train_obj2,gp_conf);

            [prediction_test_obj1, var_test_obj1] = gp_original(gp_conf.hyp_obj1, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj1,features_test);
            [prediction_test_obj2, var_test_obj2] = gp_original(gp_conf.hyp_obj2, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj2,features_test);
            tic
    else
        try
            [prediction_test_obj1, var_test_obj1] = gp_original(gp_conf.hyp_obj1, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj1,features_test);
        catch
            
            state.total_time = state.total_time + toc;
            disp('gp obj1 failed hyperparams...')
            gp_conf.hyp_obj1  = gp_find_hp(features_train, response_train_obj1,gp_conf);
            [prediction_test_obj1, var_test_obj1] = gp_original(gp_conf.hyp_obj1, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj1,features_test);
            tic
        end

        try
            [prediction_test_obj2, var_test_obj2] = gp_original(gp_conf.hyp_obj2, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj2,features_test);
        catch
            state.total_time = state.total_time + toc;
            
            disp('gp obj2 failed hyperparams...')
            gp_conf.hyp_obj2 = gp_find_hp(features_train, response_train_obj2,gp_conf);
            [prediction_test_obj2, var_test_obj2] = gp_original(gp_conf.hyp_obj2, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train_obj2,features_test);
            tic
        end
    end
    

    s_obj1 = var_test_obj1.^(1/2); 
    s_obj2 = var_test_obj2.^(1/2); 
    pop_predicted = pop_predicted.set_sigma(1:pop_predicted.num_entries,s_obj1,1);
    pop_predicted = pop_predicted.set_sigma(1:pop_predicted.num_entries,s_obj2,2);
    pop_predicted = pop_predicted.set_mu(1:pop_predicted.num_entries,prediction_test_obj1,1);
    pop_predicted = pop_predicted.set_mu(1:pop_predicted.num_entries,prediction_test_obj2,2);
                       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% intersect confidence regions %%%%%%%%%%%%%%%%%%%
    
    next_rt_mu_obj1 = zeros(length(s_obj1),1);
    next_rt_mu_obj2 = zeros(length(s_obj1),1);
    next_rt_sigma_obj1 = zeros(length(s_obj1),1);
    next_rt_sigma_obj2 = zeros(length(s_obj1),1);
    
    prev_rt_mu_obj1 = pop_predicted.get_rt_mu(:,1);
    prev_rt_mu_obj2 = pop_predicted.get_rt_mu(:,2);
    prev_rt_sigma_obj1 = pop_predicted.get_rt_sigma(:,1);
    prev_rt_sigma_obj2 = pop_predicted.get_rt_sigma(:,2);
    
    if (state.iter_train>1)
        for iter_k = 1:pop_predicted.num_entries
            %using new mean and old std dev
            area_a = [prev_rt_mu_obj1(iter_k),prev_rt_sigma_obj1(iter_k),prev_rt_mu_obj2(iter_k),prev_rt_sigma_obj2(iter_k)];
            
            area_b = [prediction_test_obj1(iter_k),s_obj1(iter_k)*state.beta,prediction_test_obj2(iter_k),s_obj2(iter_k)*state.beta];
            
            [next_rt_mu_obj1(iter_k),next_rt_sigma_obj1(iter_k),next_rt_mu_obj2(iter_k),next_rt_sigma_obj2(iter_k)]=get_intersection(area_a,area_b);
        end
        pop_predicted = pop_predicted.set_rt_mu(:,next_rt_mu_obj1,1);
        pop_predicted = pop_predicted.set_rt_sigma(:,next_rt_sigma_obj1,1);
        pop_predicted = pop_predicted.set_rt_mu(:,next_rt_mu_obj2,2);
        pop_predicted = pop_predicted.set_rt_sigma(:,next_rt_sigma_obj2,2);
          
    else
        pop_predicted = pop_predicted.set_rt_mu(1:pop_predicted.num_entries,pop_predicted.get_mu(1:pop_predicted.num_entries,1),1);
        pop_predicted = pop_predicted.set_rt_mu(1:pop_predicted.num_entries,pop_predicted.get_mu(1:pop_predicted.num_entries,2),2);
        pop_predicted = pop_predicted.set_rt_sigma(1:pop_predicted.num_entries,pop_predicted.get_sigma(1:pop_predicted.num_entries,1)*state.beta,1);
        pop_predicted = pop_predicted.set_rt_sigma(1:pop_predicted.num_entries,pop_predicted.get_sigma(1:pop_predicted.num_entries,2)*state.beta,2);
    end
    
end
