function [ partitions ] = stratified( vector,numClass,numFolds,seed )

subVectorSize=floor(length(vector)/numFolds);
partitions=zeros(subVectorSize,numFolds);

if(seed==1)
    rng(0,'twister');
end

subVectorRow=1;
subVectorColumn=1;

for i=1:numClass
    positionClass=find(vector==i);
    while length(positionClass)>1
        aux=randi([1,length(positionClass)]);
        partitions(subVectorRow,subVectorColumn)=positionClass(aux,1);
        positionClass(aux)=[];
        subVectorColumn=subVectorColumn+1;
        if subVectorColumn>numFolds
            subVectorColumn=1;
            subVectorRow=subVectorRow+1;
        end
    end
end

end
