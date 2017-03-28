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

function [mu_y1,sigma_y1,mu_y2,sigma_y2] = get_intersection(area_a, area_b)

mu_y1_a = area_a(1);
sigma_y1_a = area_a(2);
mu_y2_a = area_a(3);
sigma_y2_a = area_a(4);

mu_y1_b = area_b(1);
sigma_y1_b = area_b(2);
mu_y2_b = area_b(3);
sigma_y2_b = area_b(4);

%check if they intersect
intersect = 1;
if (mu_y1_a<mu_y1_b)
    if ((mu_y1_a+sigma_y1_a) < (mu_y1_b-sigma_y1_b));
       intersect = 0; 
    end
else
    if ((mu_y1_b+sigma_y1_b) < (mu_y1_a-sigma_y1_a));
       intersect = 0; 
    end
end
if (intersect == 1)
    %check second objective
    if (mu_y2_a<mu_y2_b)
        if ((mu_y2_a+sigma_y2_a) < (mu_y2_b-sigma_y2_b));
           intersect = 0; 
        end
    else
        if ((mu_y2_b+sigma_y2_b) < (mu_y2_a-sigma_y2_a));
           intersect = 0; 
        end
    end
end

if (intersect == 1)
    if (mu_y1_a<mu_y1_b)
        if (mu_y1_a+sigma_y1_a>=mu_y1_b+sigma_y1_b)
            sigma_y1 = sigma_y1_b;
            mu_y1 = mu_y1_b ;
        elseif (mu_y1_a-sigma_y1_a<=mu_y1_b-sigma_y1_b)
                mu_y1 = mu_y1_a;
                sigma_y1 = sigma_y1_a;
        else
            tmp = (mu_y1_a + sigma_y1_a) - (mu_y1_b - sigma_y1_b);
            tmp2 = mu_y1_b - sigma_y1_b;
            sigma_y1 = tmp /2;
            mu_y1 = tmp2 + sigma_y1;
          
        end
    else
        if (mu_y1_b+sigma_y1_b>=mu_y1_a+sigma_y1_a)
            mu_y1 = mu_y1_a;
            sigma_y1 = sigma_y1_a;
        elseif (mu_y1_b-sigma_y1_b>=mu_y1_a-sigma_y1_a)
                mu_y1 = mu_y1_b;
                sigma_y1 = sigma_y1_b;
        else
            tmp = (mu_y1_b + sigma_y1_b) - (mu_y1_a - sigma_y1_a);
            tmp2 = mu_y1_a - sigma_y1_a;
            sigma_y1 = tmp /2;
            mu_y1 = tmp2 + sigma_y1;
        end
    end
    
    if (mu_y2_a<mu_y2_b)
        if (mu_y2_a+sigma_y2_a>=mu_y2_b+sigma_y2_b)
            mu_y2 = mu_y2_b;
            sigma_y2 = sigma_y2_b;
        elseif (mu_y2_a-sigma_y2_a<=mu_y2_b-sigma_y2_b)
                mu_y2 = mu_y2_a;
                sigma_y2 = sigma_y2_a;
            
        else
            tmp = (mu_y2_a + sigma_y2_a) - (mu_y2_b - sigma_y2_b);
            tmp2 = mu_y2_b - sigma_y2_b;
            sigma_y2 = tmp /2;
            mu_y2 = tmp2 + sigma_y2;
          
        end
    else

        if (mu_y2_b+sigma_y2_b>=mu_y2_a+sigma_y2_a)
            mu_y2 = mu_y2_a;
            sigma_y2 = sigma_y2_a;
        elseif (mu_y2_b-sigma_y2_b>=mu_y2_a-sigma_y2_a)
                mu_y2 = mu_y2_b;
                sigma_y2 = sigma_y2_b;
            
        else
            tmp = (mu_y2_b + sigma_y2_b) - (mu_y2_a - sigma_y2_a);
            tmp2 = mu_y2_a - sigma_y2_a;
            sigma_y2 = tmp /2;
            mu_y2 = tmp2 + sigma_y2;
        end
    end
      
else
    %if no intersection, assigns second values
    mu_y1 = mu_y1_b;
    sigma_y1 = sigma_y1_b;
    mu_y2 = mu_y2_b;
    sigma_y2 = sigma_y2_b;
    
end
    
end

