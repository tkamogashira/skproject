function l= SPlist(SP);
% SPlist - list of stimparameters stored in SPstruct
%   SPlist(SP) returns struct containing fields with names
%   that equal the respective fieldnames of the elements
%   of SPstruct array SP, and values that equal the fullnames.
%
% Example:
%  SP(1) = SPstruct('Fcar_L', 'left carrier frequency', 'Hz', 100:100:600);
%  SP(2) = SPstruct('Fcar_R', 'right carrier frequency', 'Hz', 100:100:600);
%  SPlist(SP)
%  ans = 
%     FCAR_L: 'left carrier frequency'
%     FCAR_R: 'right carrier frequency'
%
% See also SPstruct, PlotVar

for ii=1:length(SP),
   eval(['l.' SP(ii).shortname ' = '''  SP(ii).fullname ''';'])
end
