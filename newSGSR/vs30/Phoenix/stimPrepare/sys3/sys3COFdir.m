function DD = sys3COFdir  
% RCOdir - returns folder where COF circuits are stored in *.rco files.  
%
%   By convention the COF dir is the "RPvds" subdirectory of the
%   directory in which sys3COFdir itself resides.
%   
%   See also loadCOF  
  
DD = fileparts(which(mfilename)); % temporary hack: dir where this mfile resides  
  
% append  'rpvds'  
DD = [DD '\RPvds'];  
  
  
  
  
  
