function CLO = corrListObject(List, varargin)
% CORRLISTOBJECT  Creates a corrListObject instance
%
% A corrListObject instance contains information about which sequences
% should be taken into account when calculating correlograms.
% Upon construction, all spike trains are extracted and stored in the
% object.
% Refer to calcCorr for details about calculating correlograms.
%
% CLO = corrListObject(List, parameters)
%   Constructs an instance CLO of corrListObject.
%
%         List: For ease of use, this list can be generated using genCorrList.
%               This list is struct array containing information about which
%               spiketrains to use. It contains the following fields:
%                 * filename
%                 * iseqp
%                 * isubseqp
%                 * iseqn
%                 * isubseqn
%                 * discernvalue
%               Each line refers to a certain set of spiketrains, corresponding
%               to a certain stimulus. Discernvalue is the value of the
%               independent variable at each line.
%
%   parameters: Given in name, value pairs.
%               Parameters available: 
%                Name:             Default value:
%                 * anWin           'burstdur'
%                 * corBinWidth     0.05
%                 * corMaxLag       5
%                 * norm            'Driesnorm'
%
% Example:
%   >> List = genCorrList(struct([]), 'A0306', [60;61;76;77;78;79;80], [+1, -1], 'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
%   >> CLO = corrListObject(List, 'corMaxLag', 10)
%   CLO = 
% 	  corrListObject object: 1-by-1

%% process arguments
checkStructIn(List);
CLO.props = processParams(varargin, defaultValues);
[dummy, CLO.props.lag] = SPTCORR([], [], CLO.props.corrMaxLag, CLO.props.corrBinWidth);

%% load spike trains and extra info
for nTr=1:length(List)
    CLO.list(nTr) = loadDS(List(nTr), CLO.props.anWin);
end

%% construct class
CLO = class(CLO, 'corrListObject');