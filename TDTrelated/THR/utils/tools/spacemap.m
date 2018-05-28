function S = spacemap(D);
% spacemap - overview of disk space of directory structure
%   spacemap('Foo') displays an overview of the disk space used by files in
%   folder Foo and its subfolders.
%
% See also DIR, rdir.

dd = rdir(D);
total_kbyte = sum([dd.bytes])/2^10; % total # kbytes of D & subdirs
allF = {dd.folder};
Flist = unique(allF)';
colw = 3+max(cellfun(@length,Flist)); % width of first column of list
lastdir = '******';
for idir=1:numel(Flist),
    thisdir = Flist{idir};
    padspace = blanks(colw-length(thisdir));
    imatch = strmatch(thisdir, allF); % indices in dd of files in thisdir and subdirs
    kbyte = sum([dd(imatch).bytes])/2^10; % # kbytes of thisdir & subdirs
    perc = 100*kbyte/total_kbyte;
    if isempty(strfind(thisdir, lastdir)), PreStr = '====='; else, PreStr = '     '; end
    fprintf('%s%s%s:  %7.f kByte (%0.1f %%)\n', PreStr, thisdir, padspace, round(kbyte), perc);
    lastdir = thisdir;
    S(idir) = collectInStruct(thisdir, kbyte, perc, PreStr, padspace);
end







