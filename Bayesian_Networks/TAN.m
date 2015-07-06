function results=TAN(featuresForTraining,featuresForTest,classesForTraining,n,ns)
% This function obtains TAN.
% Then the function trains it to learn the parameters of the CPDs and
% finally test it.

% INPUTS
% featuresForTraining - matrix with data for training, where each row is a
%                       case and the columns are the corresponding variable 
% featuresForTest - matrix with data for test with the same struct that
%                   featuresForTraining
% classesForTraining - vector with classes for training
% n - number of variables in featuresForTraining and featuresForTest
% ns - vector containing the possible values for each variable, including
%      the class

% OUTPUTS
% results - vector with the predicted classes for featuresForTest 

    addpath(genpath('bnt-master'));
    
    Graf=learn_struct_tan([featuresForTraining,classesForTraining]', n+1, randi(n), ns);
    bnet=mk_bnet(Graf,ns);
    
    for i=1:n+1
        bnet.CPD{i}=tabular_CPD(bnet,i);
    end
    
    bnet=learn_params(bnet,[featuresForTraining,classesForTraining]');

    engine = jtree_inf_engine(bnet);
    evidence = cell(1, n+1);
    
    [m l]=size(featuresForTest);
    
    maxPriori=0;
    aux=0;
    for i=1:max(classesForTraining)
        a=find(classesForTraining==i);
        if (length(a)>aux)
            aux=length(a);
            maxPriori=i;
        end
    end
    
    results = zeros(m, 1);
    for j=1:m
        for i=1:n 
            evidence{i} = featuresForTest(j, i); 
        end
        marginal = marginal_nodes(enter_evidence(engine, evidence), n+1);
        maxMarginal=find(marginal.T == max(marginal.T));
        if (length(maxMarginal)>1)
            results(j, 1)=maxPriori;
        else
            results(j, 1) = maxMarginal;
        end
    end
