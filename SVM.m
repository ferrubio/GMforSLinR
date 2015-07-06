function [results] = SVM(featuresForTraining,featuresForTest,classesForTraining,classesForTest,numClasses, type, bPesos)
%PRUEBA1 Summary of this function goes here
%   Detailed explanation goes here
    addpath(genpath('libsvm'));
    

    if(bPesos==1) %Weights      

        a = [];
        for i=1:numClasses
            a = [a;sum(classesForTraining==i)];
        end

        aux=a / sum(a);
        aux=1-aux;
        aux=aux/sum(aux);

        pesos = sprintf('-s 0 -q -t %d',type);
        for i=1:numClasses
            pesos = strcat(pesos,{' '},'-w',num2str(i),{' '}, num2str(aux(i)));
        end

        modellineal = svmtrain(classesForTraining, featuresForTraining, pesos);
        %model_linear = svmtrain(classesForTraining, featuresForTraining, '-s 0 -t 0 -w1 4 -w2 1 -w3 4 -w4 4 -w5 4 -q');​

        [predictedLabels, a, ~] = svmpredict(classesForTest, featuresForTest,  modellineal,'-q');
        results=predictedLabels;

    
    elseif(bPesos==2) %subsampling
        
        a = sum(classesForTraining==1);
        for i=2:numClasses
            if a>sum(classesForTraining==i)
                a = sum(classesForTraining==i);
            end
        end
        classesBalanced=[];
        featuresBalanced=[];
        for i=1:numClasses
            auxBalanced=find(classesForTraining==i);
            auxBalanced=auxBalanced(1:a,:);
            classesBalanced=[classesBalanced;classesForTraining(auxBalanced,:)];
            featuresBalanced=[featuresBalanced;featuresForTraining(auxBalanced,:)];

        end

        model = svmtrain(classesBalanced, featuresBalanced, sprintf('-t %d -q',type));

        [predictedLabels, a,~] = svmpredict(classesForTest, featuresForTest,  model,'-q');
        results=predictedLabels;

    elseif(bPesos==3) %oversampling
        a = sum(classesForTraining==1);
        for i=2:numClasses
            if a<sum(classesForTraining==i)
                a = sum(classesForTraining==i);
            end
        end
        classesBalanced=[];
        featuresBalanced=[];
        for i=1:numClasses
            auxBalanced=[];
            b=sum(classesForTraining==i);
            total=a;
            while (total>0) 
                if total<b
                    findBalanced=find(classesForTraining==i);
                    auxBalanced=[auxBalanced;findBalanced(1:total,:)];
                    total=0;
                else
                    findBalanced=find(classesForTraining==i);
                    auxBalanced=[auxBalanced;findBalanced];
                    total=total-b;
                end
            end
            classesBalanced=[classesBalanced;classesForTraining(auxBalanced,:)];
            featuresBalanced=[featuresBalanced;featuresForTraining(auxBalanced,:)];

        end

        model = svmtrain(classesBalanced, featuresBalanced, sprintf('-t %d -q',type));

        [predictedLabels, a,~] = svmpredict(classesForTest, featuresForTest,  model,'-q');
        results=predictedLabels;

    else
        model = svmtrain(classesForTraining, featuresForTraining, sprintf('-t %d -q',type));
         
        [predictedLabels, a,~] = svmpredict(classesForTest, featuresForTest,  model,'-q');
        results=predictedLabels;
    end
end

