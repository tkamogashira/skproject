function p = CreatePlotInfo(xlabel, varValues, XScale, maxY, TimeWindowStyle, VVlabels, Ptype, varargin);
% CreatePlotInfo(xlabel, varValues, XScale, maxY, TimeWindowStyle, VVlabels, Ptype, varargin);

if nargin<5, TimeWindowStyle='BurstOnly'; end;
if nargin<6, VVlabels=''; end;
if nargin<7, Ptype='spikeRate'; end;

if isnan(maxY), % default is 50 spikes/s
   maxY = 50;
end

% parse xlabel for units
VVunit = '';
Paren1 = findstr(xlabel,'(');
Paren2 = findstr(xlabel,')');
if isequal(1,length(Paren1)) & isequal(1,length(Paren2)),
   if Paren1<Paren2,
      VVunit = xlabel((Paren1+1):(Paren2-1));
      % substitute 'u' for '\m'
      mu = findstr('\mu', VVunit);
      if length(mu)==1, 
         VVunit(mu) = 'u';
         VVunit(mu+1) = '';
         VVunit(mu+1) = '';
      end
   end
end


p = struct( ...
   'xlabel',    xlabel, ...
   'varValues', varValues, ...
   'varValueUnit', VVunit,...
   'VVlabel', [],...
   'XScale',    XScale, ...
   'PlotType',  Ptype, ...
   'TimeWindowStyle', TimeWindowStyle);

p.VVlabel = local_getVarValueInfo(p, VVlabels);
for ii=1:length(varargin)/2,
   p = setfield(p,varargin{2*ii+[-1 0]});
end

%------------------------------------
function VVstr = local_getVarValueInfo(plot_info, VVlabels);
% var Values labeling the subsequences
if ~isempty(VVlabels),
   N = size(VVlabels, 1);
   VVstr = cell(1,N);
   for ii=1:N, 
      s = VVlabels(ii,:);
      s(s==' ') = '';
      VVstr{ii} = s;
   end
   return;
end
XplotValues = plot_info.varValues; 
N = length(XplotValues);
VVstr = cell(1,N);
if isnumeric(plot_info.varValues),
   VVunit = [' ' plot_info.varValueUnit];
   for ii=1:N,
      vv = plot_info.varValues(ii);
      if abs(vv)>100, 
         vv=0.1*round(vv*10); 
      elseif abs(vv)>10, 
         vv=0.01*round(vv*100); 
      end;
      VVstr{ii} = [num2str(vv) VVunit];
   end
elseif isstr(plot_info.varValues),
   for ii=1:N,
      VVstr{ii} = [' (' deblank(plot_info.varValues(ii,:)) ')'];
   end
end


