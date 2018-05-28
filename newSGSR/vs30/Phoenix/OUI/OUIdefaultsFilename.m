function [FFN, exists, pp, S] = OUIdefaultsFilename(S, RFN);
% OUIdefaultsFilename - full filename for storage of OUI defaults
%   OUIdefaultsFilename returns the full name of the file used 
%   for storage of defaults of the current OUI.
%   The name is derived fom the type and name of the first paramset 
%   contained in the OUI.
%
%   OUIdefaultsFilename(S) uses paramset object S to generate the filename.
%   OUIdefaultsFilename([]) is the same as OUIdefaultsFilename.
%
%   OUIdefaultsFilename(S, 'foo') returns 'XXX\foo.ouidef' where XXX is
%   the subdirectory derived from S.name. The directory is created if it 
%   does not exist yet.
%   OUIdefaultsFilename(S, '?get') launches uigetfile to prompt the
%   user for a .ouidef file. The folder is like XXX above. If the
%   user cancels, '' is returned.
%   OUIdefaultsFilename(S, '?put') likewise launches uiputfile.
%
%   [FN, E, saveFlags, S] = OUIdefaultsFilename(..)  also returns a logical 
%   value E indicating if the file FN exists, a cell array of strings 
%   saveFlags, and the factory values of the primary paramset S.
%   SaveFlag contains {'-mat' '-append'} if E and {'-mat'} if ~E; it can
%   be used to load parameters to the defaults flag using LOAD.
%
%   See also OUIpos, paramOUI.

if nargin<1, S = []; end
if nargin<2, RFN = ''; end % requested filename

if isempty(S),
   GD = ouidata;
   S = GD.ParamData(1);
end

S = S(1);

if isempty(RFN),
   FN = [S.type '_' S.name];
   FFN = [uidefdir filesep FN '.ouidef'];
else,
   DDIR = [uidefdir filesep S.Name];
   % create dir if non-existent
   if ~exist(DDIR, 'dir'),
      [DD NN] = fileparts(DDIR);
      mkdir(DD,NN); 
   end
   switch lower(RFN),
   case '?get',
      [nn pp] = uigetfile([DDIR filesep '*.ouidef'], 'filename for retrieval of parameters.');
      if isequal(0,pp), FFN = '';
      else, FFN = [pp filesep nn];
      end
   case '?put',
      [nn pp] = uiputfile([DDIR filesep '*.ouidef'], 'filename for storage of current parameters.');
      if isequal(0,pp), FFN = '';
      else, % make sure file is in correct dir and has right extension
         [pp nn] = fileparts([DDIR filesep nn]);
         FFN = [DDIR filesep nn '.ouidef'];
      end
   otherwise, FFN = [DDIR filesep RFN '.ouidef'];
   end
end


exists = exist(FFN, 'file');
if exists, pp = {'-mat' '-append'};
else, pp = {'-mat'};
end



