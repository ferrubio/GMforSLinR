classdef PHOG < Descriptors
% PHOG descriptor extends Descriptor class
%   Options:
%   - Bins: Number of bins on the histogram
%   - Level: number of pyramid levels
%   - Angle: 180 or 360

    properties
        Bins=360;
        Level=0;
        Angle=360;
    end
    
    methods
        
        function obj = PHOG(dataset)
        % Constructor
            obj.Name = 'PHOG';
            obj.Dataset=dataset;
        end
        
        function hist=extract(obj)
        % OVERWRITE: Creates a histogram where each row is the result of 
        % apply anna_phog over a image with the selected options. If the
        % features were previously extracted, the function reads the file
        % where the features were stored.
        
            featuresFiles=extract@Descriptors(obj);
            images=obj.Dataset.getImages();
            
            variables=obj.Bins;
            if obj.Level~=0
                for i=1:obj.Level
                    variables=variables+4^i*360;
                end
            end
            
            hist=zeros(size(featuresFiles,1),variables);
            
            for i=1:size(featuresFiles,1)
                if (exist(featuresFiles{i,1},'file'))
                    load(featuresFiles{i,1},'features');
                else
                    features=obj.generateFeatures(images{i});
                    obj.storeImage(images{i},features);
                end
                hist(i,:)=features;
            end
%             
%             descriptorPath=obj.generateDescriptorPath();
%             
%             numFiles=length(images);
%             
%             fullPath=fullfile(descriptorPath,obj.Level,obj.Bins);
%             
%             hist=zeros(numFiles,obj.Bins);
%             
%             for i=1:numFiles
%                 try
%                     if(obj.Angle==360)
%                         load(strcat(fullPath,'/',images{i},'.mat'),'features');
%                     elseif(obj.Angle==180)
%                         load(strcat(fullPath,'/',images{i},'180.mat'),'features');
%                     end
%                 catch
%                     features=obj.generateFeatures(images{i});
%                 end
%                 hist (i,:) = features;
%             end
        end
    end
    
    methods (Access=protected)
        
        function optionsPath = getOptionsPath(obj)
        % OVERWRITE: Returns the intermediate folder for store the features
        % files
        
            optionsPath=sprintf('Level_%d-Bins_%d-Angle_%d/',obj.Level,obj.Bins,obj.Angle);
        end
                
        function features=generateFeatures(obj,image)
        % This functions extract the features from one single image using
        % the Pyramid Histogram of Oriented Gradient
        
            path=fullfile(obj.Dataset.SourcePath,image);
            I=imread(path);
            features = anna_phog(path,obj.Bins,obj.Angle,obj.Level,[1;size(I,1);1;size(I,2)]);
        end
        
    end
    
end

