classdef DataSourceAbs < handle
    %DATASOURCEABS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access=protected, Constant)
        BasePath = pwd;
    end
    
    properties
        Name;
        SourcePath;
    end
    
    methods (Abstract)
        [images, varargout] = getImages(obj);
    end
    
    methods 
        function dictionaryPath =getDictionaryPath(obj)
            dictionaryPath=obj.Name;
        end
    end
end

