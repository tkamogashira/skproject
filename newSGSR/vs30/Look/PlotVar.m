function PV = PlotVar(SParray, MLexpr, shortname, fullname, unit, logAxis);
% PlotVar - define plot variable from stimulus parameters
%   PlotVar(SParray, MLexpr, shortname, name, unit, logAxis) returns a structure
%   with fields:
%    shortname: Capitalized char string, short description for plot labeling
%     fullname: char string, full description of plot variable
%         unit: char string, physical unit of plot variable
%        value: vector containing values of the plot variable in Playing Order 
%      logAxis: 0|1|2 ~ no|preferred|always {default: no}
%   
%   The values are extracted from SParray by evaluating char string MLexpr
%
%   Example:
%   SP(1) = SPstruct('Fcar_L', 'Left carrier frequency', 'kHz', [1 1.2 1.4]);
%   SP(2) = SPstruct('Fcar_R', 'Right carrier frequency', 'kHz', [1.002 1.205 1.402]);
%   PV1 = PlotVar(SP, 'abs(Fcar_L-Fcar_R)*1e3', 'Fbeat', 'Beat frequency', 'Hz')
%   PV1 = 
%    shortname: 'FBEAT'
%     fullname: 'Beat frequency'
%         unit: 'Hz'
%        value: [2 5 2]
%
%   Note: make sure to use uppercase references to the shortnames in SParray and
%   use element-wise (array-) multiplication, etc, when needed.
%
%   See also SPstruct

if nargin<6, logAxis = 0; end;

% "unpack" shortnames
for ii=1:length(SParray),
   eval([SParray(ii).shortname '=' 'SParray(ii).value;']);
end

% evaluate MLexpr
value = eval(MLexpr);
PV = CollectInStruct(shortname, fullname, unit, value, MLexpr, logAxis);

