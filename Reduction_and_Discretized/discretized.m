function [data]=discretized(data,ns)
% This function discretize the continuous values from data using a matrix
% of points. The range between points represents the numbers with the same
% discrete value and the position in the matrix this value.
%
%IN:
%	data - dataset matrix with continuous values
%   bins - vector with the bins of each variable
%
%OUT:
%	data - dataset matrix with discrete values
    
    [m, n]=size(data);
    
    count=sum(ns==1);
    
    corte=1/count;
    points=[corte/2;corte;corte*2;1];
    
    for j=1:n
        if (ns(j)==1)
            for i=1:m
                for k=1:length(points)
                    if points(k)> data(i,j)
                        data(i,j)=k;
                        break;
                    end
                end
            end
        end
    end
