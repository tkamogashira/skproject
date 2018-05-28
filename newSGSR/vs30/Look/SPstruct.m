function SP = SPstruct(shortname, fullname, unit, value);
% SPstruct - returns stimparam struct variable for new-style data storage
%   Syntax: SP = SPstruct(shortname, fullname, unit, value);
%   This returns fixed-format struct SP with fields:
%       shortname: Capitalized char string, short description for plot labeling, etc
%        fullname: char string, full description of parameter
%            unit: char string, physical unit of parameter
%           value: single number or vector containg the values in Playing Order (!)
%
% Example:
%  SP = SPstruct('FcarL', 'left carrier frequency', 'Hz', 100:100:600);
%  SP = 
%     shortname: 'FCARL'
%      fullname: 'left carrier frequency'
%          unit: 'Hz'
%         value: [100 200 300 400 500 600]
%
% See also TexUnit, PlotVar, SPlist

shortname = upper(shortname);
SP = CollectInStruct(shortname, fullname, unit, value);