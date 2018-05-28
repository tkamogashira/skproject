function E = ExportData(FN, figh);
% ExportData - export data from analysis plot to txt file
%   ExportData('foo') exports the data in the current data plot to a file foo.txt.
%   Default folder is <SgSRroot>\export
%   If no file is specified, the user is prompted for a filename.
%   
%   ExportData('foo', figh) plots the data from figure with handle figh.

if nargin<1, FN = ''; end;    % dataplotExport will prompt
if nargin<2, figh = gcf; end;

dataplotExport(figh, 'file', FN);





