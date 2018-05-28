function [RAPStat, LineNr, ErrTxt] = RAPCmdHI(RAPStat, LineNr, FirstToken, varargin)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 02-08-2005

%-------------------------------------RAP Syntax------------------------------------
%   HI BF @@..@@              Binning freq for cyc histograms supplied as expression
%   HI BFI #1 #2              Binning freq for cyc histograms to start at #1 Hz and
%                             increase by #2 Hz each time
%   HI BFV #1 [#2 ...]        Binning freq for cyc histograms supplied as vector of 
%                             constant values. Length must be equal to number of recorded
%                             subsequences (*)
%   HI BF DEF                 Histogram binning frequency to default
%   HI SH #                   Histograms to be shaded using specified color
%   HI SH DEF                 Histogram shading to default  
%   HI UN                     Histograms to be unshaded
%   HI OUT/FULL               Histogram outlines only or full bars
%   HI HI/LI                  Histogram bars or line connecting centers
%   HI YV RATE/COUNT/NORM     Hist. Y-axis to be spike rate,count or normalized
%-----------------------------------------------------------------------------------

%------------------------------implementation details-------------------------------
%   Specifying the binning frequency with a beginning frequency and a step size
%   requires a dataset to be specified ...
%-----------------------------------------------------------------------------------

ErrTxt = '';

if (nargin == 2), FirstToken = 'disp'; end
switch FirstToken,
case 'disp',
   if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
      fprintf('Histogram plot parameters\n');
      fprintf('-------------------------\n');
      if isequal('hist', RAPStat.PlotParam.Hist.Sort), % Sort has higher priority than Style
          fprintf('Style         : %s\n', RAPStat.PlotParam.Hist.Style);
      else
          fprintf('Style         : %s\n', RAPStat.PlotParam.Hist.Sort);
      end
      fprintf('Facecolor     : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Hist.FaceColor));
      fprintf('Edgecolor     : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Hist.EdgeColor));
      fprintf('Ordinate unit : %s\n', RAPStat.PlotParam.Hist.YAxisUnit);
   end
case 'full',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   RAPStat.PlotParam.Hist.Style = 'bars';
case 'out',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   RAPStat.PlotParam.Hist.Style = 'outline';
case 'hi',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   RAPStat.PlotParam.Hist.Sort = 'hist';
case 'li',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   RAPStat.PlotParam.Hist.Sort = 'line';
case 'yv', 
   if (nargin == 3),
      if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
         fprintf('The ordinate unit for histograms is %s\n', RAPStat.PlotParam.Hist.YAxisUnit);
      end
   else, 
      if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
      RAPStat.PlotParam.Hist.YAxisUnit = varargin{1}; 
   end    
case 'sh',
   if (nargin == 3),
      if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'),
         fprintf('Histogram facecolor : %s\n', ConvRAPStatColor(RAPStat.PlotParam.Hist.FaceColor));
      end
   else,
      if strcmpi(varargin{1}, 'def'),
         RAPStat.PlotParam.Hist.FaceColor = ManageRAPStatus('PlotParam.Hist.FaceColor');
      elseif ~any(strcmpi(varargin{1}, {'r', 'g', 'b', 'y', 'c', 'm', 'k'})), 
         ErrTxt = 'Invalid color symbol'; return; 
      else, RAPStat.PlotParam.Hist.FaceColor = ColSym2RGB(varargin{1}); end
   end
case 'un',    
   RAPStat.PlotParam.Hist.FaceColor = RAPStat.PlotParam.Axis.Color;
case 'bfi',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   ds = RAPStat.GenParam.DS;
   
   [Bgn, Step, ErrTxt] = GetRAPFloat(RAPStat, varargin{:});
   if ~isempty(ErrTxt), return; end
   RAPStat.CalcParam.BinFreq = Bgn + Step * (0:ds.nrec-1)';
case 'bfv',
   if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
   Nrec = RAPStat.GenParam.DS.nrec;
   if (nargin ~= (Nrec + 3)), ErrTxt = 'Number of constant values must be equal to number of recorded subsequences.'; return; end
   RAPStat.CalcParam.BinFreq = cat(1, varargin{:});
case 'bf',
   if (nargin == 3),
      if isRAPStatDef(RAPStat, 'ComLineParam.Verbose'), 
         [Str, Err] = GetRAPCalcParam(RAPStat, 's', 'BinFreq'); if ~isempty(Err), Str = 'default'; end
         fprintf('Current binning frequency is %s.\n', Str);
      end
   elseif strcmp(varargin{1}, 'def'), RAPStat.CalcParam.BinFreq = ManageRAPStatus('CalcParam.BinFreq');
   else, 
      if isRAPStatDef(RAPStat, 'GenParam.DS'), ErrTxt = 'No dataset specified'; return; end
      
      if isRAPSubstVar(varargin{1}, 'char'), %Character substitution variable ...
         ErrTxt = 'Character substitution variable cannot replace a numerical expression'; return; 
      else, %Valid numerical expression ...
         [PFExpr, ErrTxt] = TransExprIF2PF(varargin{1}); if ~isempty(ErrTxt), return; end
         Value = EvalPFExpr(RAPStat, PFExpr); 
         if isempty(Value), ErrTxt = 'Could not evaluate expression'; return; end
         if ~unique(sign(Value)), ErrTxt = 'Binning frequencies must be all of same sign'; return; end
         
         RAPStat.CalcParam.BinFreq = Value;
      end
   end    
end    

LineNr = LineNr + 1;