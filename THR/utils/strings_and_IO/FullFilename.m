function F = FullFilename(F, DefDir, DefExt);
% FullFilename - create full file name from name and default dir & ext
%   FullFilename(F, DefDir, DefExt) provides directory and extension
%   to filename F, but only if F doesn't have one yet.
%   So DefDir and DefExt are default values that can be overruled by F's
%   own directory and/or extension. DefExt may or may not start with a dot.
%
%   See also FullFile, Fileparts.

if nargin<2, DefDir = ''; end
if nargin<3, DefExt = ''; end

[DD dum EE] = fileparts(F);
if isempty(DD), % no dir spcified; provide default dir
    F = fullfile(DefDir, F);
end
if isempty(EE), % no extension spcified; provide default ext
    if ~isempty(DefExt),
        % provide dot if needed
        if ~isequal('.', DefExt(1)), 
            DefExt = ['.' DefExt];
        end
        F = [F DefExt];
    end
end


