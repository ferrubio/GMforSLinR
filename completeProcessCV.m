function completeProcessCV(dataset, robot, classifier, n, numClasses, numFolds, SVMoptions)

% INPUTS
% dataset 
%
% 0 --> KTH-IDOL
% 1 --> COLD

% robot
%
% 0 --> Dumbo (KTH-IDOL) / Freiburg (COLD)
% 1 --> Minnie (KTH-IDOL) / Ljubljana (COLD)
% 2 --> Saarbrucken (COLD)

% classifier
%
% 0 --> SVM
% 1 --> Naive Bayes continuous
% 2 --> Naive Bayes discrete
% 3 --> Bayesian Network MCMC
% 4 --> Bayesian Network K2-Order MWST
% 5 --> Bayesian Network BNPC
% 6 --> Bayesian Network IC
% 7 --> Bayesian Network TAN

% n - number of variables for discrete classifiers
% numClasses - number of bins of class variable
% numFolds - number of folds for cross validation

% SVMoptions - two values vector
%   first value select the kernel:
% 	0 --> linear (defect)
%	1 --> polynomial
%	2 --> radial basis function
%	3 --> sigmoid
%   second value stablish the balanced options:
%	0 --> none (defect)
%	1 --> adds the weight argument of libsvm
%	2 --> subsampling of mayority class
%	3 --> oversampling the minority class or classes

% OUTPUTS
% The function creates a .mat file in output folder, where the accuracy
% and confusion matrix are stored.

if nargin < 7
    SVMoptions = [0,0];
end

addpath(genpath('datasetClass'));
if(dataset==0)
    dataP=KTH_IDOLDataset();
    if(robot==0)
        dataP.SelectedRobot='Dumbo';
    elseif(robot==1)
        dataP.SelectedRobot='Minnie';
    else
        error('Error in second parameter (robot): Select 0 (Dumbo) or 1 (Minnie)');
    end
elseif(dataset==1)
    dataP=COLDDataset();
    dataP.SelectedPath='PartA-Path1';
    if(robot==0)
        dataP.SelectedRobot='Freiburg';
    elseif(robot==1)
        dataP.SelectedRobot='Ljubljana';
    elseif(robot==2)
        dataP.SelectedRobot='Saarbrucken';
    else
        error('Error in second parameter (robot): Select 0 (Freiburg), 1 (Ljubljana) or 2 (Saarbrucken)');
    end
else
    error('Error in first parameter (dataset): Select a value between 0 and 1');
end

dataP.SelectedSequences={'Cloudy1','Cloudy2','Cloudy3','Cloudy4','Night1','Night2','Night3','Night4','Sunny1','Sunny2','Sunny3','Sunny4'};
classes=dataP.getClasses;


addpath(genpath('descriptors'));
p=PHOG(dataP);

if or(classifier==0,classifier==1)
    p.Bins=360;
else
    p.Bins=n; 
end

features=p.extract();

ns=ones(1,size(features,2));

if classifier>1
    addpath(genpath('Reduction_and_Discretized'));
    features=discretized(features,ns);
    ns=[4*ones(1,size(features,2)),numClasses];
end


% Clasificador
%
% 0 --> SVM
% 1 --> Naive Bayes continuo
% 2 --> Naive Bayes discreto
% 3 --> Bayesian Network MCMC
% 4 --> Bayesian Network K2-Orden MWST
% 5 --> Bayesian Network BNPC
% 6 --> Bayesian Network IC

partitions=stratified(classes,numClasses,numFolds,1);

totalAccuracy=0;

for folds=1:numFolds
    
    indexForTraining=[];
    for i=1:numFolds
        if(i==folds)
            indexForTest=partitions(:,i);
        else
            indexForTraining=[indexForTraining,partitions(:,i)];
        end
    end
    indexForTest(indexForTest==0) = [];
    indexForTraining(indexForTraining==0) = [];
    
    featuresForTraining=features(indexForTraining,:);
    featuresForTest=features(indexForTest,:);
    
    classesForTraining=classes(indexForTraining,:);
    classesForTest=classes(indexForTest,:);
    
    if (classifier>2)
        addpath(genpath('Bayesian_Networks'));
    end

    if(classifier==0)
        results = SVM(featuresForTraining,featuresForTest,classesForTraining,classesForTest,numClasses,SVMoptions(1),SVMoptions(2));

    elseif(classifier==1)
        prueba=NaiveBayes.fit(featuresForTraining,classesForTraining);
        results=prueba.predict(featuresForTest);

    elseif(classifier==2)
        prueba=NaiveBayes.fit(featuresForTraining,classesForTraining,'Distribution','mn');
        results=prueba.predict(featuresForTest);

    elseif(classifier==3)
        results=MCMC(featuresForTraining,featuresForTest,classesForTraining,n,ns);

    elseif(classifier==4)
        results=K2(featuresForTraining,featuresForTest,classesForTraining,n,ns);

    elseif(classifier==5)
        results=bnpc(featuresForTraining,featuresForTest,classesForTraining,n,ns);

    elseif(classifier==6)
        results=IC(featuresForTraining,featuresForTest,classesForTraining,n,ns);

    elseif(classifier==7)
        results=TAN(featuresForTraining,featuresForTest,classesForTraining,n,ns);

    end

    accuracy=sum(results==classesForTest)/(sum(results==classesForTest)+sum(results~=classesForTest));
    totalAccuracy=totalAccuracy+accuracy;
    
    cMat1 = confusionmat(classesForTest,results);

    dataResults=struct;
    dataResults.accuracy=accuracy;
    dataResults.cMat=cMat1;

    if (classifier~=0)
        outFile = fullfile('.', 'output', ...
        sprintf('resultsCV%d_dataset%d_robot%d_classifier%d_n%d_numFolds%d.mat',folds, dataset,robot,classifier,n,numFolds));
    else        
        outFile = fullfile('.', 'output', ...
        sprintf('resultsCV%d_dataset%d_robot%d_classifier%d_n%d_numFolds%d_SVM%d_balan%d.mat',folds, dataset,robot,classifier,n,numFolds,SVMoptions(1),SVMoptions(2)));
    end
    
    if (~exist('output','dir'))
        mkdir('output');
    end

    save(outFile,'dataResults');

end
totalAccuracy=totalAccuracy/numFolds;
if classifier~=0
    outFile = fullfile('.', 'output', ...
        sprintf('resultsCV_dataset%d_robot%d_classifier%d_n%d_numFolds%d.mat', dataset,robot,classifier,n,numFolds));
else
    outFile = fullfile('.', 'output', ...
        sprintf('resultsCV_dataset%d_robot%d_classifier%d_n%d_numFolds%d_SVM%d_balan%d.mat', dataset,robot,classifier,n,numFolds,SVMoptions(1),SVMoptions(2)));
end
save(outFile,'totalAccuracy');

end

