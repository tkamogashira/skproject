function plotcalibfile(Ftype, fileName);
% plotCalibFile - plot calibration curve from user-selected file 

if nargin<2, 
   fileName = ''; 
else,
   [fp fn ee] = fileParts(fileName);
   fp = [fp '\'];
   fn = [fn ee];
end

switch upper(Ftype)
case {'CAV', 'PRB', 'PRL'},
   if isempty(fileName),
      [fn fp] = uigetfile([Calibdir '\*.PRB;*.PRL;*.CAV'], ...
         'select PRL/CAV/PRB file to view');
      if isequal(fn,0), return; end
   end
   load([fp fn], '-MAT');
   wname = ['Transfer function: ' fn]; % default plot-window name
   if exist('PRBtransfer'), 
      plotcalib(PRBtransfer, wname, fn);
   elseif exist('PRLtransfer'), 
      plotcalib(PRLtransfer, wname, fn);
   elseif exist('CAVtransfer'), 
      plotcalib(CAVtransfer, wname, fn);
   end
case 'ERC',
   if isempty(fileName),
      [fn fp] = uigetfile([datadir '\*.ERC*'], ...
         'select ERC file to view');
      if isequal(fn,0), return; end;
   end
   load([fp fn], '-MAT');
   wname = ['Transfer function: ' fn]; % default plot-window name
   if exist('ERCLtransfer') & exist('ERCRtransfer'),
      chch = warnchoice1('Select D/A Channel to plot', '', '\Channel to plot:', 'Left','Right');
      switch chch,
      case 'Left',  plotcalib(ERCLtransfer, wname, [fn 'L']);
      case 'Right',  plotcalib(ERCRtransfer, wname, [fn 'R']);
      end
   elseif exist('ERCLtransfer'), plotcalib(ERCLtransfer, wname, fn);
   elseif exist('ERCRtransfer'), plotcalib(ERCRtransfer, wname, fn);
   else, return;
   end;
otherwise, % must be a full filename; parse it and try again
   [pp nn ee] = fileParts(Ftype);
   plotcalibfile(upper(ee(2:end)), Ftype);
end % switch

