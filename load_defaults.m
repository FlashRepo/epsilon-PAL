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

function [conf,state,gp_conf] = load_defaults(config_file)
    gp_conf = struct;
    %auxiliary variables
    [keynames,values]=textread(config_file,'%s=%s');
    v = str2double(values); idx = ~isnan(v);
    values(idx) = num2cell(v(idx));
    conf = cell2struct(values, keynames); 

    if (strcmp(class(conf.epsilon_list),'double')==0)
        conf.epsilon_list = str2num(conf.epsilon_list); 
    end
    if (exist(conf.results_folder,'file')==0)
        system(['mkdir ',conf.results_folder]);
    end
    if (isfield(conf,'train_set_exist')==0)
        conf.train_set_exist=0;
    end
    if (isfield(conf,'print_progress')==0)
        conf.print_progress=0;
    end
    if (isfield(conf,'infinite')==0)
        conf.infinite=0;
        conf.print_progress = 1;
    end
    state.refill_pop = 0;
    state.duplicates_out =0;
    state.not_p_out = 0;
    state.count_rounds = 0;
    if (isfield(conf,'eliminate_duplicates')==0)
        conf.eliminate_duplicates=0;
    end
    if conf.eliminate_duplicates==1
        conf.num_hashes_duplicates = 100;
        conf.num_projections_duplicates = 6; 
    end
 
    if(isfield(conf,'train_set_in_file')==0)
        conf.train_set_in_file = strcat(conf.results_folder,'train_out.csv')
    end

    %make sure that in run mode only one epsilon is taken
    if (conf.test_mode == 0)
        conf.epsilon_list = conf.epsilon_list(1);
    end

    gp_conf.meanfunc = {@meanConst}; 
    %gp_conf.covfunc = {@covSEard}; 
        
    gp_conf.covfunc = {@covSum, {@covLINone, @covSEard}}; 
    gp_conf.likfunc = @likGauss; 
    gp_conf.hyp_obj1 = 0; gp_conf.hyp_obj2 = 0;
    gp_conf.post_obj1 = 0; gp_conf.post_obj2 = 0
    

    %other variables
    conf.gap_hyp_update = 1000;
    conf.gap_random_sample = 40; %every x iterations a random sample is taken

    state.beta=3; %default value, this will be overwritten
    conf.plot_prediction = 0; % for debugging, the design space can be plotted on every iteration

    conf.num_objectives = 2;
    
    if (conf.test_mode == 0) || (conf.infinite == 1)
        conf.number_of_repetitions = 1;
    end
    
    if (isfield(conf,'factor_beta')==0)  
        conf.features_max_values = 5;
    end
    if (isfield(conf,'features_max_values')==0)  
        conf.features_max_values = ones(1,conf.num_features);
    end
    if (isfield(conf,'features_min_values')==0)  
        conf.features_min_values = zeros(1,conf.num_features);
    end
    if (isfield(conf,'features_step')==0)  
        conf.features_step = ones(1,conf.num_features).*-1;
    end

end
