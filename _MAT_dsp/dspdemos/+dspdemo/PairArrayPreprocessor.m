classdef PairArrayPreprocessor < matlab.System
    %PairArrayPreprocessor Helper object for pair array preprocessing
    %   H = dspdemo.PairArrayPreprocessor returns preprocessor.
    %
    %   H = dspdemo.PairArrayPreprocessor('Name', Value, ...) returns a 
    %   preprocessor with each specified property name set to the specified
    %   value. You can specify additional name-value pair
    %   arguments in any order as (Name1,Value1,...,NameN,ValueN).
    %
    %   Step method syntax:
    %
    %   Y = step(H, X) outputs a buffer Y of size 
    %   BufferLength x numBuffers x 2 x numPairs. X is of size 
    %   InputSamples x numMicrophones. 
    %
    %   PairArrayPreprocessor methods:
    %
    %   step               - See above description for use of this method
    %   release            - Allow property value and input characteristics
    %                        changes
    %   getPairSeparations - returns the inter-microphone spatial distances
    %                        for the pairs provided
    %
    %   PairArrayPreprocessor properties:
    %
    %   MicPositions       - Positions of all microphones within array
    %   MicPairs           - Microphone pairs within the array
    %   BufferLength       - Length of output buffers
    
    % Copyright 2013 The MathWorks, Inc.
    
    properties(Access = public)
        % MicPositions microphone positions as spatial coordinates
        % e.g. for 3D case use [[x1;y1;z1], [x2;y2;z2], ..., [xN;yN;zN];
        % for 1D use [x1, ..., xN]
        MicPositions = [0.11, 0.078, 0.042, -0.088];
        % MicPairs defines how microphones are coupled together to form
        % pairs
        MicPairs = [4, 1; 4, 2; 4, 3];
        % BufferLength defines the length of the output buffers
        BufferLength = 64;
    end
    
    methods
        % Constructor
        function obj = PairArrayPreprocessor(varargin)
            setProperties(obj, nargin, varargin{:});
        end
    end
    
    methods(Access = protected)
        function reshapedFrame = stepImpl(obj, unformattedFrame)
            NumPairs = size(obj.MicPairs, 1);
            L = obj.BufferLength;
            % Number of buffers available in the input frame
            nBuffers = floor(size(unformattedFrame, 1)/L);
            % Preallocate output data frame
            reshapedFrame = zeros(obj.BufferLength, ...
                nBuffers, 2, NumPairs);
            % Reshape input buffer
            for kPair = 1:NumPairs
                reshapedFrame(:,:,1,kPair) = reshape(unformattedFrame(:,...
                    obj.MicPairs(kPair,1)), L, nBuffers);
                reshapedFrame(:,:,2,kPair) = reshape(unformattedFrame(:,...
                    obj.MicPairs(kPair,2)), L, nBuffers);
            end
            if(nBuffers == 1)
                reshapedFrame = squeeze(reshapedFrame);
            end
        end
    end
    
    methods(Access = public)
        function micSeparations = getPairSeparations(obj)
            micSeparations = sqrt(sum(...
                (obj.MicPositions(:,obj.MicPairs(:,1)) - ...
                obj.MicPositions(:,obj.MicPairs(:,2))).^2, 1));
        end
    end
end