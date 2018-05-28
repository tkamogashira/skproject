function [D, FN, I] = methoddirs(A);
% methoddirs - list method @ directories for given object class
%    methoddirs(A) or methoddirs('Foo'), where class(A)= 'Foo' produces 
%    a list of @Foo directories that are subdirectories of the Matlab path. 
%    Any mfiles in these directories are valid Foo methods.
%
%    [S, FN, I] = methoddirs(A) returns the directories in a cell array of 
%    strings S. The full filenames are in returned in cell array FN, and I
%    is an index array such that method FN{J} is in directory I(J).
%
%    See also methodshelp, methods.

if ~ischar(A), A = class(A); end

M = methods(A);
Nmethod = length(M); % # methods
D = {}; 
FN = cell(1,Nmethod);
I = zeros(1,Nmethod);
for ii=1:Nmethod,
    Mname = [A '/' M{ii}];  %e.g.  '@cell/permute'
    mf = which(Mname); 
    if isempty(mf),
        %warning(['Method ''' Mname ''' not found.']);
        continue; % inherited method?
    end
    d = fileparts(mf); % candidat directory
    if isempty(strmatch(d,D,'exact')), % not in list D yet
        D = [D d];
        % D,d,mf, M{ii}
        % disp('------------')
    end
    FN{ii} = mf;
    idir = strmatch(d,D,'exact');
    I(ii) = idir; % index array; see
end
inotfound = find(~I); % zero entries
I(inotfound) = [];
FN(inotfound) = [];
if nargout<1, % just list, don't return
    prettyprint(D);
    clear D
end
    
    
