function hist=variableReduction(hist,variables)
% This function reduces the number of variables to the selected value.
% The function joins the probabilities in a range in order to reduce them.
%
%IN:
%	hist - histogram matrix with all the variables
%   variables - number of varaibles for output
%
%OUT:
%	hist - histogram matrix with the number of selected variables


    [m,n]=size(hist);
    aux=zeros(m,variables);
    bin=n/variables;
    aux2=0;
    for i=1:variables
        for j=1:m
            aux(j,i)=sum(hist(j,int16(aux2)+1:int16(aux2+bin)));
        end
        aux2=aux2+bin;
    end
    hist=aux;
