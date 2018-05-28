function putcache(cfn, Nmax, Param, Data, MatVersion);
% putcache - store stuff cache
%    putcache('Foo', Nmax, Param, Data) stores Data in cache file Foo,
%    where it may be retrieved by Getcache. Nmax is the max number of
%    Data entries in Foo. Param is a parameter that uniquely specifies the
%    stored Data. The cache filename may be a full filename, but if it is
%    not complete, a default Dir (tempdir) and extension ('.ncache') is
%    provided.
%
%    putcache('Foo', Nmax, Param, Data, '-Vxxx') uses a specific version
%    of Matlab binary files for storage. See SAVE. The default is the
%    current version of Mat files.
%
%    See also getcache, rmcache.

MatVersion = arginDefaults('MatVersion', {}); % default: current Mat version
MatVersion = cellify(MatVersion);

MaxCacheBytes = 20e6; % max size of single cache files. Larger caches will be distributed over separate files
% estimate max size of cache file, assuming that all instances of Data have
% same size
qq=whos('Data');
TotNbyte = Nmax*qq(1).bytes;

% check if Param was used before
[ihit, CFN, ParamList]=matchcache(cfn,Param);
CFNexists = ~isempty(ParamList);

new_item.Param = Param;
new_item.time = now;
new_item.inseparatefile = (TotNbyte>MaxCacheBytes);

Nlist = numel(ParamList);
if isempty(ParamList), % CFN does not exist
    ihit = 1;
    clear ParamList; 
elseif ~isempty(ihit), % CFN exists and contains earlier version of Param. Replace.
elseif Nlist<Nmax, % Param is new in CFN, and there is room to append it
    ihit = Nlist+1; 
else, % Param is new, but CFN is full
    ihit = matchcache(CFN); % this returns oldest entry
end
% name data to match index ihit.
DataVar = ['Data_' num2str(ihit)];
eval([DataVar ' = Data;']);

new_item.datavar = DataVar;
new_item.filename = '';
ParamList(ihit) =  new_item;

% save Data & Params
if CFNexists, 
    PendingArgs = {'-mat' MatVersion{:} '-append'};
else,
    PendingArgs = {'-mat' MatVersion{:}};
end
if new_item.inseparatefile,
    [dum cfn ext] = fileparts(CFN); % cfn is only filename
    Datafile = strrep(CFN, cfn, [cfn '_' DataVar]); % data are stored in separate files foo_Data_1, etc
    ParamList(ihit).filename = [cfn '_' DataVar ext]; % store only name of datafile+ ext; this keeps cache files portable
    save(Datafile, DataVar, 'ParamList', '-mat');
    save(CFN, 'ParamList', PendingArgs{:});
else,
    save(CFN, DataVar, 'ParamList', PendingArgs{:});
end











