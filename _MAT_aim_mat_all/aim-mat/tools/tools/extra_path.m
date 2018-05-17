% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% http://www.pdn.cam.ac.uk/cnbh/aim2006
% $Date: 2008-06-10 18:00:16 +0100 (Tue, 10 Jun 2008) $
% $Revision: 585 $

function extra_path
udir = 'units';
if exist(udir,'dir')
   udir = [pwd '\units'];
   A = dir('units');
   for i=3:length(A)
      if (A(i).isdir)
         addpath(fullfile(udir,A(i).name),'-end')
      end
   end
   addpath('tools','-end')
else
   disp('Change to ''mfiles'' folder and try again')
end
