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

function [hyp] = gp_find_hp(features_train, response_train,gp_conf)
            %disp('find hpp')
            size_features=size(features_train);
            num_features=size_features(2);
            %hyp.cov=[0];
            hyp.cov=[0;0];

            for i = 1:num_features
               hyp.cov=[hyp.cov;0];
            end
            
            %num of elements required in hyp.cov = feval(gp_conf.covfunc{:})
            
            hyp.mean = [0]; 
            hyp.lik = log(0.1);

            hyp = minimize(hyp, @gp, -100, @infExact, gp_conf.meanfunc, gp_conf.covfunc, gp_conf.likfunc, features_train, response_train);
            
end

