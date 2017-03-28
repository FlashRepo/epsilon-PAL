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

function plot_gp_predictions(pop_sampled,pop_predicted,real_pareto_set)                           
    figure()
    hold on 
    real_obj1 = [pop_sampled.get_real_obj(:,1);pop_predicted.get_real_obj(:,1)];
    real_obj2 = [pop_sampled.get_real_obj(:,2);pop_predicted.get_real_obj(:,2)];
    prediction_obj1 = [pop_sampled.get_real_obj(:,1);pop_predicted.get_rt_mu(:,1)];
    prediction_obj2 = [pop_sampled.get_real_obj(:,2);pop_predicted.get_rt_mu(:,2)];
    s_obj1 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(:,1)];
    s_obj2 = [zeros(pop_sampled.num_entries,1);pop_predicted.get_rt_sigma(:,2)];
    one_is_pareto = [zeros(pop_sampled.num_entries,1);pop_predicted.get_pareto(:)];
    %one_is_pareto = [pop_sampled.get_real_obj(:,2);pop_predicted.get_real_obj(:,2)];
    real_pareto_01list = zeros(pop_predicted.num_entries+pop_sampled.num_entries); %get_pareto_01list([pop_sampled.get_real_obj(:,1);pop_predicted.get_real_obj(:,1)],[pop_sampled.get_real_obj(:,2);pop_predicted.get_real_obj(:,2)]);

    for i = 1:length(prediction_obj1)
	u_a=prediction_obj1(i);
        u_t=prediction_obj2(i);
        s_a = s_obj1(i);
        s_t = s_obj2(i);

        obj1_vector = [u_a+s_a,u_a+s_a,u_a-s_a,u_a-s_a,u_a+s_a];
        obj2_vector = [u_t+s_t,u_t-s_t,u_t-s_t,u_t+s_t,u_t+s_t]; 
                                  
        if (one_is_pareto(i))
                if (real_pareto_01list(i))
                        line(obj1_vector,obj2_vector,'Color','g','LineStyle','--');
                else
                        line(obj1_vector,obj2_vector,'Color','g','LineStyle','-');
                end
        else

                if (real_pareto_01list(i))
                        line(obj1_vector,obj2_vector,'Color','b','LineStyle','--');
                else
                            line(obj1_vector,obj2_vector,'Color','b','LineStyle','-');
                end

         end
     end
                            
     for i = 1:length(prediction_obj1)
     	u_a=prediction_obj1(i);
        u_t=prediction_obj2(i);
        s_a = s_obj1(i);
        s_t = s_obj2(i);

        if (one_is_pareto(i))
        	scatter(u_a, u_t, 'MarkerFaceColor','g','MarkerEdgeColor','g');
        else 
                	scatter(u_a, u_t,'MarkerFaceColor','b','MarkerEdgeColor','b');
                %else
                %        scatter(u_a, u_t, 'MarkerFaceColor','g','MarkerEdgeColor','g');
                %        disp('not pareto not nop')
                %        scatter(u_a, u_t,'MarkerEdgeColor','black');
        end                    
        line([u_a,(real_obj1(i))],[u_t, (real_obj2(i))],'Color','y');
        scatter((real_obj1(i)),(real_obj2(i)),'MarkerEdgeColor','r');
     end
    real_pareto_obj1 = real_pareto_set{1};
    real_pareto_obj2 = real_pareto_set{2};
    scatter(real_pareto_obj1,real_pareto_obj2,10,'MarkerFaceColor','k','MarkerEdgeColor','k')


end
