function S = sys3ParTag(Dev, TagName, TagProp);
% sys3ParTag - list parameter tags of a circuit and their properties
%   sys3ParTag(Dev) displays a list of al Tags with their data type.
%
%   S = sys3tagList(Dev) returns a stuct array S whose elements correspond 
%   to the tags of the circuit, and whose fields contain the info on each
%   ParTag: Name, DataType, TagSize, TagValue.
%
%   sys3tagList(Dev, 'Foo') only returns the info on tag Foo. 
%   Matching of Tag names must be exact and is case sensitive.
%   sys3tagList(Dev, '') is equivalent to sys3tagList(Dev).
%
%   S = sys3tagList(Dev, 'MyTag', Prop) only returns the specified property
%   Prop of MyTag. Prop must be one of DataType, TagSize. (sloppy matching
%   of these keywords is allowed).
%
%   See also sys3setPar, sys3getPar, sys3read, sys3write, sys3circuitInfo.

if nargin<1, Dev = ''; end % default device
if nargin<2, TagName = ''; end % default: all tags
if nargin<3, TagProp = ''; end % default: all props

error(sys3unloadedError(Dev));
if isempty(Dev), Dev = sys3defaultdev; end
    
S = sys3circuitInfo(Dev, 'ParTag');

if ~isempty(TagName),
    imatch = strmatch(TagName, {S.Name},'exact');
    if isempty(imatch),
        Dev = private_devicename(Dev);
        error(['No ParTag named ''' TagName ''' exists in circuit loaded to ' Dev '.']);
    end
    S = S(imatch);
end

if ~isempty(TagProp),
    if length(S)>1, error('Selected ParTag properties may only be queried from individual ParTags.'); end
    [TagProp, Mess] = keywordMatch(TagProp, fieldnames(S), 'Tag propeerty');
    error(Mess);
    S = S.(TagProp);
end

if nargout<1, % display, don't return anything
    [dum, Cname] = fileparts(sys3circuitInfo(Dev, 'CircuitFile'));
    if nargin<2, disp(['ParTags in circuit ' upper(Cname) ' currently loaded to ' Dev ':']); end
    if isstruct(S),
        for ii=1:length(S),
            disp(' ');
            disp(S(ii))
        end
    else, % selected proprty of single ParTag
        disp(S);
    end
    clear S;
end














