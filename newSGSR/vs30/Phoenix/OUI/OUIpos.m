function OUIpos = OUIpos(X);
% OUIpos - save or retrieve position on screen of current OUI
%   OUIpos('save') saves the postion of the current OUI
%   in a setup file whose name is derived fom the type and the name of the 
%   first paramset contained in the OUI (see OUIdefaultsFilename).
%   The next time the same OUI is openend by paramOUI,
%   the position will be restored. 
%
%   P = OUIpos(S) retrieves the position of a OUI. If a setup
%   file is found that matches paramset S (see OUIdefaultsFilename), 
%   the position stored in that file is returned. If no matching setup 
%   file is found, MatLab's default figure position is returned.
%
%   See also paramOUI, OUIdefaultsFilename.

persistent MATLAB_DEFAULT_FIGPOS

if isequal('save', X),
   GD = OUIdata;
   OUIpos = get(OUIhandle, 'position');
   [FN EX pp] = OUIdefaultsFilename;
   save(FN, 'OUIpos', pp{:});
else, % retrieval
   [FN EX] = OUIdefaultsFilename(X);
   OUIpos = [];
   if EX, 
      try, 
         warning off; 
         load(FN, 'OUIpos', '-mat'); 
         warning backtrace; 
      end
   end
   if isempty(OUIpos), % return MATLAB_DEFAULT_FIGPOS
      if isempty(MATLAB_DEFAULT_FIGPOS), % initialize MATLAB_DEFAULT_FIGPOS
         qq = figure('visible', 'off');
         set(qq, 'units', 'points');
         MATLAB_DEFAULT_FIGPOS = get(qq, 'position');
         delete(qq);
      end
      OUIpos = MATLAB_DEFAULT_FIGPOS;
   end
end











