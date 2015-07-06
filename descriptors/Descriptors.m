classdef Descriptors < handle
% Abstract class
%   Descriptors have two fixed variables:
%   - Name: that stores the name of the descriptor that we will apply
%   - Dataset: is an object that must have the elements of a dataset (see
%       KTH_IDOLDataset)
%
%   In order to create a new descriptor, one functions may be
%   overwritten:
%   - features = generateFeatures(image): that extract features depend on
%       the descriptor
%
    
    
    properties
        Name;
        Dataset;
    end
    
    methods (Access=protected,Abstract)
        features = generateFeatures(obj,image);
    end
    
    methods
%         function applyDescriptor(obj)
%             images=obj.Dataset.getImages();
%             numFiles=length(images);
%                         
%             for i=1:numFiles
%                 obj.generateFeatures(images{i});
%             end 
%         end
%         
%         function featuresStruct = extract(obj)
%             descriptorPath=obj.generateDescriptorPath();
%             
%             images=obj.Dataset.getImages();
%             numFiles=length(images);
%             
%             featuresStruct=cell(numFiles,1);
%             
%             for i=1:numFiles
%                 fileName=strcat(descriptorPath,'/',images{i},'.mat');
%                 
%                 if(~exist(fileName,'file'))
%                     obj.generateFeatures(images{i});
%                 end
%                 featuresStruct{i}=fileName;
%             end
%         end
%         
        function featuresFiles = extract(obj)
        % Creates a cell array with all full paths of the files that store
        % the features corresponding to the selected images. This function
        % can be overwritten in order to obtain directly a struct with the 
        % features instead of the path.
            images=obj.Dataset.getImages();
            for i=1:size(images,1)
                [dirName baseName]=fileparts(images{i});
                images{i}=fullfile(dirName,baseName);
            end
            featuresFiles = strcat(obj.getDescriptorPath(),'/',obj.getOptionsPath(),obj.Dataset.Name,'/',images,'.mat');
        end
        
        function storeImage(obj,imageName,features)
        % This function helps to store in the correct place the features
        % extract with generateFeatures function. It needs the image name
        % and the features extract.
        
            [dirName baseName]=fileparts(imageName);
            imageName=fullfile(dirName,baseName);
        
            descriptorPath = strcat(obj.getDescriptorPath(),'/',obj.getOptionsPath(),obj.Dataset.Name,'/',imageName,'.mat');
            
            bars=find(descriptorPath=='/');
            dirName=descriptorPath(1:bars(end));
            if (~exist(dirName,'dir'))
                mkdir(dirName);
            end
            
            save(descriptorPath,'features');
        end
        
        function dictionaryPath =getDictionaryPath(obj)
            dictionaryPath=fullfile(MainPath(),'dictionaries',obj.Name,obj.getOptionsPath,obj.Dataset.getDictionaryPath);
        end
        
        function storeDictionary(obj,dictionary)
        
            dictionaryPath = obj.getDictionaryPath();
            
            if (~exist(dictionaryPath,'dir'))
                mkdir(dictionaryPath);
            end
            
            save(fullfile(dictionaryPath,'dictionary.mat'),'dictionary');
        end
        
    end
    methods (Access=protected)
        
        function optionsPath = getOptionsPath(obj)
        % Creates a String with an intermediate path between the descriptor
        % folder and the image. This function return a empty String, but it
        % is advisable to overwrite then with at least one intermediate 
        % folder for the differents options of the descriptor
        
            optionsPath='';
        end
        
        function descriptorPath=getDescriptorPath(obj)
        % Generates the full path of the descriptor and it adds also the
        % dataset name
        
            descriptorPath=fullfile(pwd,'features',obj.Name);
        end
        
    end
end

