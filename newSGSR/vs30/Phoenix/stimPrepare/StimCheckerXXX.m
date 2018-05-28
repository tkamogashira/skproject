function OK = StimCheckerXXX(, varargin);
% StimCheckerXXX - template for stimulus checker
%   StimCheckerXXX(S, CT) checks if the stimulus parameter set 
%   in stimparam object S is realizable, given stimlus context CT.
%   If S is valid, StimCheckerXXX returns true.
%
%   See also StimulusContext, StimulusDashboard.

OK = 0;
GD = ouiData;
stimName = GD.ParamData(1).name;

StimParam = readOUI(stimName);
if ~isvoid(StimParam),
   stimChecker = ['stimCheck' stimName];
   if exist(stimChecker, 'file'),
      OK = feval(stimChecker, StimParam, StimulusContext);
   else,
      OUIerror({'Stimchecker function for', ...
            ['''' stimName ' '' stimulus is not implemented.'], ...
            bracket(['function ' stimChecker ' not found'], 1, '()')});
   end
end





