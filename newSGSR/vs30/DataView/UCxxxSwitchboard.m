%  UCxxxSwitchboard script
% This switch board script is called from within ucXXX functions which have a generic
% function syntax decripbed in the help text of UCrate.
%
%  Note: upon entrance, callerfnc should be set to the mfilename of the ucXXX function to enable
%  recursive calls, etc.

if nargin<1, % callback from menu
   keyword = get(gcbo, 'tag');
   if isempty(keyword), keyword = curDS; end; % lazy syntax for debugging
end


% fill non-existent varargins with []
for ii=max(1,nargin):100, varargin{ii} = []; end

if isa(keyword,'dataset'),
   ds = keyword;
   keyword = 'newplot';
end

switch keyword,
case {'factory'}, % ======== params = ucXXX('factory')
   varargout{1} = localDefaultParams(0);
case {'defaults'}, % ======== params = ucXXX('defaults')
   varargout{1} = UCdefaults(callerfnc);
case 'params',        % ========  params = ucXXX('params', ds, iSub, prop, val, ...)
   [ds, iSub]= deal(varargin{1:2});
   varargout{1} = GetDataViewParams(callerfnc, ds, iSub, varargin{3:end});
case 'guiparams',     % read params from GUI
   error NYI
case 'compute',       %  ======== result = ucXXX('compute', ds, iSub, params)
   %                  %  OR====== result = ucXXX('compute', ds, iSub, prop, val, ...)
   [ds, iSub, params] =  deal(varargin{1:3});
   if ~isstruct(params), % get parameters default values for this dataset
      params = GetDataViewParams(callerfnc, ds, iSub, varargin{3:end});
   end;
   varargout{1} = localComputeIt(ds, params);
case 'plot',          %  ======== [figh, results] = ucXXX('plot', figh, results)
   %                  %  OR====== [figh, results] = ucXXX('plot', figh, ds, ....)
   figh = varargin{1};
   if isstruct(varargin{2}),  results = varargin{2};
   else % recompute from params in args
      eval(['results = ' callerfnc '(''compute'', varargin{2:end});']); % recompute
   end
   figh = localPlotIt(results, figh);
   [varargout{1:2}] = deal(figh, results);
case 'newplot',       %  ======== [figh, results] = ucXXX(ds, iSub, figh, params)
   %                  %  OR====== [figh, results] = ucXXX(ds, iSub, figh, prop, val, ...)
   [iSub figh]= deal(varargin{1:2});
   params = GetDataViewParams(callerfnc, ds, iSub, varargin{3:end}); % get params
   % --compute:   result = ucXXX('compute', ds, iSub, params)
   eval(['results = ' callerfnc '(''compute'', ds, iSub, params);']); 
   % --plot: [figh results] = ucXXX('plot', ds, iSub, params)
   eval(['[figh results] = ' callerfnc '(''plot'', figh, results);']); 
   [varargout{1:2}] = deal(figh, results);
case 'localfunction',  %  ====varargout = ucXXX('localfunction', funcname, nargout, var1, ...)
   [funcname, Nargout] = deal(varargin{1:2});
   varargout = cell(1,Nargout);
   argoutStr = '[';
   for ii=1:Nargout,
      argoutStr = [argoutStr ' varargout{' num2str(ii) '}'];
   end
   argoutStr = [argoutStr '] = '];
   if Nargout==0, argoutStr = ''; end
   cmd = [argoutStr funcname '(varargin{3:nargin-1});'];
   eval(cmd);
otherwise, % deal with standard set of keywords
   OK = StandardDataPlotFunctions(keyword, gcf, gcbf);
   if ~OK, error(['Unknown keyword ''' keyword '''']); end;
end
