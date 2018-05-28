%  UCxxxParamSwitchboard script
% This switch board script is called from within ucXXXparam functions which have a generic
% function syntax. 
% See also UCxxxSwitchboard
%
%  Note: upon entrance, the following variables must be set:
%      callerfnc:  mfilename of the calling ucXXXparam function. This is also used as callback
%      keyword & varargin of the caller
%      DialogName: name of GUI fig file to be opened by OpenDialog
%      

%  UCxxx:  mfilename of the UCxxx function that does the analysis, e.g., UCrate
UCxxx = strsubst(callerfnc, 'Param', ''); % UCrateParam -> 


if nargin<1, % callback from menu
   keyword = get(gcbo, 'tag');
end

% fill non-existent varargins with []
for ii=max(1,nargin):100, varargin{ii} = []; end

if isstruct(keyword), % a lazy syntax for commandline tests
   varargin = {nan keyword curds 'debug'};
   keyword = 'init';
end

switch keyword,
case {'initcurrent', 'initdefaultanalysis'},
   defa = isequal('initdefaultanalysis', keyword);
   [CallerHandle ds, params, debug]= deal(varargin{1:4});
   hh = opendialog(DialogName, callerfnc, 'Root:position');
   setUIprop(hh.Root, 'Iam.Level', 'Current'); % default level: only current set is affected, no default settings changed
   if defa, 
      set(hh.Root, 'Color', [0.853 0.753 0.753]); 
      params = ucDefaults(UCxxx); % get current defaults
      setUIprop(hh.Root, 'Iam.Level', 'Defaults');
   end;
   if ishandle(CallerHandle), % retrieve all info from caller's fig handle ...
      HeIs = getUIhandle(CallerHandle, 'Iam', 'userdata'); % .. and store in own figure
      setUIprop(hh.Root, 'Iam.Caller', HeIs);
      ds = HeIs.showing.ds; % dataset under inspection
      if ~defa, params = HeIs.showing.params; end
   end
   % store this info in order to be self-supporting
   setUIprop(hh.Root, 'Iam.CallerHandle', CallerHandle);
   setUIprop(hh.Root, 'Iam.ds', ds);
   setUIprop(hh.Root, 'Iam.params', params);
   % fill edits with current values
   localFillEdits(hh, params);
   if isempty(debug), % debug: do not obstruct testing
      set(hh.Root, 'windowstyle', 'modal');
      waitfor(hh.Root);
   end
case 'CancelButton', 
   delete(gcbf);
case 'close', 
   dialogDefaults(gcf, 'savecurrent');
   delete(gcf);
case 'DefaultButton',
   eval(['defpar = ' UCxxx '(''factory'');']);
   localFillEdits(gcbf, defpar);
case 'ApplyButton',
   curparams = getUIprop(gcbf, 'Iam.params');
   newparams = localReadEdits(gcbf);
   if isempty(newparams), return; end;
   newparams = combineStruct(curparams, newparams);
   plothandle = getUIprop(gcbf, 'Iam.CallerHandle');
   ds = getUIprop(gcbf, 'Iam.ds');
   eval(['[plothandle, RAT] = ' UCxxx '(''plot'', plothandle, ds, [], newparams);']);
   eval([UCxxx '(''plot'', plothandle, ds, [], newparams);']);
   setUIprop(gcbf, 'Iam.CallerHandle', plothandle); % plot to same fig next time
case 'OKButton', % = apply + close, but watch out which window to close!
   figh = gcbf;
   eval([callerfnc ' ApplyButton;']); 
   Level = getUIprop(figh, 'Iam.Level');
   if isequal('Defaults', Level),
      params = localReadEdits(figh); % read current values ...
      ucdefaults(UCxxx, params); %  ... save them
   end
   close(figh);
case 'readParam', % debug option
   newparams = localReadEdits(gcf);
case '',    
case 'keypress',
    case 'resize',
otherwise, error(['Unknown keyword ''' keyword '''']);
end











