classdef KTH_IDOLDataset < DataSourceAbs
    %CLEFDATABASES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Robot;
        Sequences;
        Classes;
        Format;
        
        SceneRobot;
        SceneSequence;
        SceneClass;
        SceneTime;
        SceneX;
        SceneY;
        SceneZ;
        
        
        % TODO: A�ADIR COMPROBACI�N DE VALORES
        SelectedSequences;   % Selected sequences
        SelectedRobot;        % Selected type
    end
    
    properties (Access=protected, Dependent)
        SelectedIndex;
    end
    
    properties (Access=private)
        DataFile = fullfile(DataSourceAbs.BasePath, 'datasets', 'KTH-IDOL', 'info.mat'); % info.mat
    end
    
    methods
        % Constructor
        function obj = KTH_IDOLDataset()
            load(obj.DataFile, 'data');

            obj.Name = data.name;
            obj.SourcePath = fullfile(DataSourceAbs.BasePath, 'datasets', 'KTH-IDOL');
            
            obj.Robot=data.robotLabel;
            obj.Sequences = data.sequenceLabel;
            obj.Classes = data.classLabel;
        
            obj.SceneSequence = data.sceneSequence;
            obj.SceneClass = data.sceneClass;
            obj.SceneTime = data.sceneTime;
            obj.SceneX=data.sceneX;
            obj.SceneY=data.sceneY;
            obj.SceneZ=data.sceneZ;
            obj.SceneRobot=data.sceneRobot;
            
            obj.Format = data.Format;
        end

        function images = getImages(obj)
            if isempty(obj.SelectedRobot)
                error('KTH_IDOLDatabase:selectedRobotEmpty', 'No selected robot. Please, set property SelectedRobot to ''Dumbo'' or ''Minnie''');
            end
            
            idx = obj.SelectedIndex;
            fileNameFormat = obj.Format;
            
            sequenceLabel = obj.getSequencePath(idx)';
			sceneClassLabel = obj.Classes(1,obj.SceneClass(idx))';
            sceneTimeLabel = obj.SceneTime(idx);
			sceneXLabel = obj.SceneX(idx);
			sceneYLabel = obj.SceneY(idx);
			sceneZLabel = obj.SceneZ(idx);
            sceneRobot = obj.Robot(obj.SceneRobot(idx))';
            images = cellfun(@(robot,seq,t,cl,x,y,z) sprintf(fileNameFormat,robot,seq,t,cl,x,y,z), sceneRobot,sequenceLabel,num2cell(sceneTimeLabel), ...
                sceneClassLabel,num2cell(sceneXLabel),num2cell(sceneYLabel),num2cell(sceneZLabel),'UniformOutput', false);
            
        end
        
        function SelectedIndex = get.SelectedIndex(obj)
            secuencesId=[];
            robotId=[];           
            for i=obj.SelectedSequences
                secuencesId=[secuencesId,find(strcmp(obj.Sequences, i))];
            end
            robotId=[robotId,find(strcmp(obj.Robot, obj.SelectedRobot))];
            SelectedIndex = and(ismember(obj.SceneSequence, secuencesId),ismember(obj.SceneRobot, robotId));
        end
        
        function classes=getClasses(obj)
            classes = obj.SceneClass(obj.SelectedIndex);
        end
        
        function conditions=getConditions(obj)
            conditions = obj.SceneSequence(obj.SelectedIndex);
            conditions = floor((conditions-1)/4);
        end
        
%         function applyDescriptor(obj,descriptor)
%             images=obj.getImages();
%             addpath(genpath('Descriptors'));
%             numFiles=length(images);
%             
%             for i=1:numFiles
%                 image_path=fullfile(obj.SourcePath,images{i});
%                 if(strcmp(descriptor,'PHOG'))
%                     edges = phog_modified(image_path,360);
%                     save(strcat(DataSourceAbs.BasePath,'features/PHOG/KTH-IDOL/',images{i},'.mat'),'edges');
%                 elseif(strcmp(descriptor,'PHOG180'))
%                     edges = phog_modified(image_path,180);
%                     save(strcat(DataSourceAbs.BasePath,'features/PHOG/KTH-IDOL/',images{i},'180.mat'),'edges');
%                 elseif(strcmp(descriptor,'Centrist'))
%                     Im_RGB=imread(image_path);
%                     ct=centrist(Im_RGB);
%                     features=(ct/sum(ct))';
%                     save(strcat(DataSourceAbs.BasePath,'features/Centrist/KTH-IDOL/',images{i},'.mat'),'features');
%                 end
%             end
%         end
%         
%         function hist=extractHistogram(obj,descriptor,bins)
%             images=obj.getImages();
%             addpath(genpath('Descriptors'));
%             numFiles=length(images);
%             hist=zeros(numFiles,bins);
%             if(strcmp(descriptor,'PHOG'))
%                 for i=1:numFiles
%                     load(strcat(DataSourceAbs.BasePath,'features/',descriptor,'/KTH-IDOL/',images{i},'.mat'),'edges');
%                     hist(i,:)=phog_descriptor_modified(edges,360,0,bins);
%                 end
%             elseif(strcmp(descriptor,'Centrist'))
%                 addpath(genpath('Reduction_and_Discretized'));
%                 for i=1:numFiles
%                     load(strcat(DataSourceAbs.BasePath,'features/',descriptor,'/KTH-IDOL/',images{i},'.mat'),'features');
%                     hist(i,:)=variableReduction(features,bins);
%                 end
%                 
%             end
%         end

        function dictionaryPath =getDictionaryPath(obj)
            dictionaryPath=fullfile(obj.Name,sprintf('%s/',obj.SelectedRobot));
        end
    end

    methods (Access=protected)
        function sequencePath = getSequencePath(obj, idx)
            sequencePath = obj.Sequences(obj.SceneSequence(idx));
        end
    end
    
end

