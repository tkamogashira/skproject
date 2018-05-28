function [fn, L]=setupFilename(fn);
% SetupFilename - full name of setup file in  setup directory 
%   setupFilename(F) returns full name of setup file based on name F.
%   Default dir is setupdir; default extension is 'PNXsetup'.
%   These defaults are ony used if F doesn't have them.
%   By default a prefix XXX-only_ is prepended to the filename, where XXX
%   stands for the computer name (see Compuname). Such setup files
%   are considered "local setup files".
%   [FN, L] = setupFilename(F) also returns a logical L indicating whether
%   FN is a local setup file. See Tosetupfile, FromSetupfile, and ListSetup
%   for the use of local setup files.
%
%   NOTE: end users of EARLY will generally not need to call SetupFilename
%   directly, except when copying setup files to another computer.
%   Handling of setup files is handled by ToSetupFile, FromSetupFile, and
%   SetupList. Neither of these functions needs the full file name of the 
%   setup file.
%
%   setupFilename('~Foo') creates a global setup file (without the XXX-only_
%   prefix), which is also visible to other computers.
%
%   See also Compuname, ToSetupFile, FromSetupFile, setupdir.

if ~ischar(fn),
    error('Filename arg must be valid filename.');
end
CN = compuname;
prefix = [CN '-only_'];
if ~isempty(fn) && ~isequal('~', fn(1)), % local setup file
    CN = compuname;
    if isequal('??', CN), % no name has been set for this computer
        error('Computer has no known name. Use SetCompuname.');
    end
    fn = [prefix fn];
else, % global setup file. Remove tilde; do not prepend prefix
    fn = fn(2:end);
end
L = ~isempty(strmatch(lower(prefix), lower(fn))); % user might have entered prefix by hand
fn = FullFileName(fn, setupdir, 'PNXsetup');


