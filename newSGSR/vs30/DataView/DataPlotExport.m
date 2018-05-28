function E = DataPlotExport(figh, keyword, Name);
% DataPlotExport - export data plotted by UCxxx
%   syntax: DataPlotExport(figh, keyword)

% Retrieve plotted data by re-computing them with the same params ..
% .. note that results are never stored in plot, only the params
% .. which lead to the results.
DD = getUIprop(figh,'Iam.showing'); % Data Descriptor 
% recompute PD = processed data
PD = eval([DD.dataplotfnc '(''compute'', DD.ds, [], DD.params);' ]);

% format parameters to be respected by all plotType-specific functions
FormatParams = [];

if nargin<3, Name = '';  end % either filename or name of variable


% PlotType-specific header and data matrix. ...
% Specific work is Delegated to local functions: one for each plotType
plotType = DD.dataplotfnc;
localfnc = ['localExport_' plotType]; % 'localExport_ucrate' etc
try,
   [SpecHeader, DataMatrix, formatStr, AnName] = eval([localfnc '(PD, FormatParams);']);
catch
   if ~isempty(findstr('Undefined function', lasterr)),
      error(['Export of data from ''' PD.plotfnc ''' not yet implemented.']);
   else, error(lasterr);
   end
end

% generic header, final header
GenHeader = localHeader(PD, AnName);
Header = strvcat(GenHeader, SpecHeader); 

switch lower(keyword),
case 'file',
   if ~isempty(Name),
      FN = fullFileName(Name, exportdir, 'txt');
   else, % prompt user 
      [FN, FP] = uiputfile([exportdir '\*.txt'], ['Export ' PD.plotfnc ' data.']);
      if isequal(0, FN), return; end; % user cancelled
      FN = [FP FN]; % full name
   end
   [DD FF XX] = fileparts(FN);
   if isempty(XX), FN = [FN '.txt']; end; % default extention is .txt
   try, 
      fid = fopen(FN, 'wt'); 
      if fid<0, error(['Unable to open file ''' FN '''']); 
      end
   catch, errordlg(lasterr, 'Error while attempting to save data.');
   end
   Header = StrMat2Nstr(Header); % convert char matrix to \n-delimited string
   fprintf(fid, '%c', Header);
   fprintf(fid, formatStr, DataMatrix.');
   fclose(fid);
   exportdir(DD); % Set default exportdir to the directory just used 
   disp(['Data saved in ' FN]);
case {'screen'},
   disp(' ');
   disp(Header);
   fprintf(1, formatStr, DataMatrix.');
   disp(' ');
case 'var',
   while 1,
      if ~isempty(Name), 
         varname = Name;
      else, % prompt user
         varname = inputdlg({'name of MatLab variable: '}, ['Export ' PD.plotfnc ' data.']);
      end
      varname = char(varname);
      if isequal('', varname), break; end
      if isvarname(varname),
         var2base(DataMatrix, varname);
         disp([' *** Variable ''' varname ''' defined.   ***']);
         break;
      else, errordlg(['Invalid variable name ''' varname '''.'], 'Error exporting data.');
      end
   end
end
   

%---------------------------------------------
function H = localHeader(PD, AnalysisName);
ds = PD.DSinfo; % dataset info
xval = ds.xval(PD.iSub).';
xunit = ds.xunit;
H = disp(ds,0);
H(3,:) = [];
H = strvcat(H, '--------------------------------');
H = strvcat(H, ['Analysis: ' AnalysisName]);
if ~isempty(xval), H = strvcat(H, [ds.xname ': ' num2sstr(xval) ' ' ds.xunit]); end
H = strvcat(H, '--------------------------------');
% prepend '% ' to each line of the header
H = [repmat('% ', size(H,1), 1), H];

function [DM, Ncond, formstr, unitStr] = local_histData(PD);
% local_histData - return generic histogram data as data matrix.
% rate or #spikes?
switch PD.params.Yunit,
case 'Rate', 
   histfield = 'Rate';
   formstr = '%7.1f '; % floating-point format
   unitStr = 'spikes/s';
case 'Spikes',  
   histfield = 'N';
   formstr = '%5d '; % integer format
   unitStr = 'Spike count';
otherwise, error(['Unknown histogram Y-unit ''' PD.params.Yunit '''.']);
end
Ncond = length(PD.hist); % # conditions in the histogram data
formstr = repmat(formstr, 1, Ncond);
% Convert Bin edges to Bin centers
BinCenters = PD.hist(1).Edges(:);
BinCenters = (BinCenters(1:end-1)+BinCenters(2:end))/2;
DM = [BinCenters]; % first column contains bincenters ...
for icond = 1:Ncond, % ... remaining columns are counts or rates of each condition
   newcol = eval( ['PD.hist(icond). ' histfield   ';']);
   DM = [DM newcol(:)];
end

%-------analysis-specif functions below

function [H, DM, formatStr, AnName] = localExport_uccyc(PD, FormatParams);
% put UCcyc results in matrix for export and provide one-line header
[DM, Ncond, formatstr, unitStr] = local_histData(PD);
H =         ['% phi(cycle)   ' unitStr];
formatStr = ['%1.4f       ' formatstr '\n'];
AnName = 'Cycle Histogram';

function [H, DM, formatStr, AnName] = localExport_uclat(PD, FormatParams);
% put UClat results in matrix for export and provide one-line header
[DM, Ncond, formatstr, unitStr] = local_histData(PD);
H =         ['% Latency (ms)   ' unitStr];
formatStr = ['%6.1f        ' formatstr '\n'];
AnName = 'First-Spike Latency Histogram';

function [H, DM, formatStr, AnName] = localExport_ucisi(PD, FormatParams);
% put UCisi results in matrix for export and provide one-line header
[DM, Ncond, formatstr, unitStr] = local_histData(PD);
H =         ['% ISI (ms)   ' unitStr];
formatStr = ['%6.1f       ' formatstr '\n'];
AnName = 'Nth-Order Inter-Spike-Interval Histogram';

function [H, DM, formatStr, AnName] = localExport_ucpst(PD, FormatParams);
% put UCpst results in matrix for export and provide one-line header
[DM, Ncond, formatstr, unitStr] = local_histData(PD);
H =         ['% Time (ms)   ' unitStr];
formatStr = ['%6.1f       ' formatstr '\n'];
AnName = 'Post-Stimulus Spike-Time Histogram';

function [H, DM, formatStr, AnName] = localExport_ucvphase(PD, FormatParams);
% put UCvphase results in matrix for export and provide one-line header
DM = [PD.Xval(:)  PD.VS(:)  PD.PlotPhase(:)   PD.alpha(:)   ];
xlab = PD.DSinfo.xlabel;
H =         ['% ' xlab '    R      phi (cyc)   alpha'];
formatStr = ['%9.3f'  blanks(length(xlab)-5)  '%5.3f    %6.3f     %7.5f  \n'];
AnName = 'Vector Strength and Phase';

function [H, DM, formatStr, AnName] = localExport_ucrate(PD, FormatParams);
% put UCrate results in matrix for export and provide one-line header
DM = [PD.Xval(:)  PD.Nspike(:)  PD.NspikePerRep(:)   PD.Rate(:)   ];
xlab = PD.DSinfo.xlabel;
H =         ['% ' xlab '   #spikes   sp/rep    Rate (sp/s)'];
formatStr = ['%9.3f'  blanks(length(xlab)-5)  '%7.1f    %6.2f     %6.2f  \n'];
AnName = 'Rate & spike count';

function [H, DM, formatStr, AnName] = localExport_ucthr(PD, FormatParams);
% put UCthr results in matrix for export and provide one-line header
DM = [PD.Freq(:)  PD.Thr(:)];
H =         ['% Freq (Hz)   Thr (dB SPL)'];
formatStr = ['%8.1f       %5.1f  \n'];
AnName = 'Threshold Curve';




