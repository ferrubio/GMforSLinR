classdef COLDDataset < DataSourceAbs
    %CLEFDATABASES Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Robot;
        Path;
        Sequences;
        Classes;
        Format;
        Format2;
        Format3;
        
        SceneRobot;
        ScenePath
        SceneSequence;
        SceneClass;
        SceneTime;
        SceneX;
        SceneY;
        SceneZ;
        
        
        % TODO: A�ADIR COMPROBACI�N DE VALORES
        SelectedSequences;   % Selected sequences
        SelectedPath;
        SelectedRobot;        % Selected type
    end
    
    properties (Access=protected, Dependent)
        SelectedIndex;
    end
    
    properties (Access=private)
        DataFile = fullfile(DataSourceAbs.BasePath, 'datasets', 'COLD', 'info.mat'); % info.mat
    end
    
    methods
        % Constructor
        function obj = COLDDataset()
            load(obj.DataFile, 'data');

            obj.Name = data.name;
            obj.SourcePath = fullfile(DataSourceAbs.BasePath, 'datasets', 'COLD');
            
            obj.Robot=data.robotLabel;
            obj.Sequences = data.sequenceLabel;
            obj.Path=data.pathLabel;
            obj.Classes = data.classLabel;
        
            obj.SceneSequence = data.sceneSequence;
            obj.ScenePath = data.scenePath;
            obj.SceneClass = data.sceneClass;
            obj.SceneTime = data.sceneTime;
            obj.SceneX=data.sceneX;
            obj.SceneY=data.sceneY;
            obj.SceneZ=data.sceneZ;
            obj.SceneRobot=data.sceneRobot;
            
            obj.Format = data.Format;
            obj.Format2 = data.Format2;
            obj.Format3 = data.Format3;
        end

        function images = getImages(obj)
            if isempty(obj.SelectedRobot)
                error('COLDDatabase:selectedRobotEmpty', 'No selected robot. Please, set property SelectedRobot to ''Freiburg'', ''Ljubljana'' or ''Saarbrucken''');
            end
            
            if isempty(obj.SelectedPath)
                error('COLDDatabase:selectedPathEmpty', 'No selected Path. Please, set property SelectedPath to ''PartA-Path1'', ''PartA-Path2'', ''PartB-Path3'' or ''PartB-Path4''');
            end
            
            idx = obj.SelectedIndex;
            if strcmp(obj.SelectedRobot,'Freiburg')
                fileNameFormat = obj.Format;
            elseif strcmp(obj.SelectedRobot,'Ljubljana')
                fileNameFormat = obj.Format2;
            else
                fileNameFormat = obj.Format3;
            end
            sequenceLabel = obj.getSequencePath(idx)';
			sceneTimeLabel = obj.SceneTime(idx);
			sceneXLabel = obj.SceneX(idx);
			sceneYLabel = obj.SceneY(idx);
			sceneZLabel = obj.SceneZ(idx);
            sceneRobot = obj.Robot(obj.SceneRobot(idx))';
            scenePath = obj.Path(obj.ScenePath(idx))';
            
            images=cell(sum(idx),1);
            sceneTimeLabel=num2cell(sceneTimeLabel);
            sceneXLabel=num2cell(sceneXLabel);
            sceneYLabel=num2cell(sceneYLabel);
            sceneZLabel=num2cell(sceneZLabel);
            
            for i=1:sum(idx)
                if (and(and(sceneXLabel{i}==0,sceneYLabel{i}==0),sceneZLabel{i}==0))
                    images{i} = sprintf('%s/%s/%s/t%0.6f.jpeg',sceneRobot{i},scenePath{i},sequenceLabel{i},sceneTimeLabel{i});
                else
                    images{i} = sprintf(fileNameFormat,sceneRobot{i},scenePath{i},sequenceLabel{i},sceneTimeLabel{i}, ...
                    sceneXLabel{i},sceneYLabel{i},sceneZLabel{i});
                end
            end
            
        end
        
        function SelectedIndex = get.SelectedIndex(obj)
            secuencesId=[];
            pathId=[];
            robotId=[];           
            for i=obj.SelectedSequences
                secuencesId=[secuencesId,find(strcmp(obj.Sequences, i))];
            end
            pathId=[pathId,find(strcmp(obj.Path, obj.SelectedPath))];
            robotId=[robotId,find(strcmp(obj.Robot, obj.SelectedRobot))];
            SelectedIndex = and(and(ismember(obj.SceneSequence, secuencesId),ismember(obj.SceneRobot, robotId)),ismember(obj.ScenePath, pathId));
        end
        
        function classes=getClasses(obj)
            classes = obj.SceneClass(obj.SelectedIndex);
        end
        
        function conditions=getConditions(obj)
            conditions = obj.SceneSequence(obj.SelectedIndex);
            conditions = floor((conditions-1)/4);
        end
        
        function dictionaryPath =getDictionaryPath(obj)
            dictionaryPath=fullfile(obj.Name,sprintf('%s/%s/',obj.SelectedRobot,obj.SelectedPath));
        end
        
    end

    methods (Access=protected)
        function sequencePath = getSequencePath(obj, idx)
            sequencePath = obj.Sequences(obj.SceneSequence(idx));
        end
    end
    
end
