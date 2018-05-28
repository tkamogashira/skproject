function DD = sys3COFdir  
% sys3COFdir - directory where COF circuits are stored in *.rco files.  
%
%   By convention the COF dir is the "RPvds" subdirectory of the
%   directory in which sys3COFdir itself resides.
%
%   See also sys3loadCOF.
  
DD = fileparts(which(mfilename)); % dir where this mfile resides  
  
% append  'rpvds'  
DD = [DD '\RPvds'];  
 

  
  
  
