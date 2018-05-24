function disp(this)
%DISP   Display this object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

% Don't use "get" since getting the section wordlengths is very expensive
% (for the default case of "use minimum word lengths")
% s = get(this);
% fn = fieldnames(s);
fn = fieldnames(this);

% Re-order the cell-array of properties.
idx = [3 7 5 6 8];

% Reorder the fields States and InputOffset.
ispersistent = this.PersistentMemory;
if ispersistent,
    idx = [idx 1 4 9];
end
fn = fn(idx);

for i=1:length(fn),
    snew.(fn{i}) = get(this, fn{i});
end

snew = changedisplay(snew,'PersistentMemory',mat2str(ispersistent));

% Look for extra new line feeds, we want to get rid of them all.
sndx = min(regexp(snew, '\w'));
sndx = max(find(snew(1:sndx-1) == char(10)));
snew(1:sndx) = [];

sndx = max(regexp(snew, '\w'));
sndx = min(find(snew(sndx:end) == char(10)))+sndx;
snew(sndx:end) = [];

% If PersistentMemory is turned off, don't bother trying to do this
% replacement.
if this.PersistentMemory
    snew = strrep(snew, sprintf('[1x%d filtstates.cic]', length(this.States)), ...
        dispstr(this.States, 29));
end

snew = ['    ' snew(1:end-1)];
snew = strrep(snew, sprintf('\n'), sprintf('\n    '));

disp(snew)

if strcmpi(get(0, 'formatspacing'), 'loose')
    disp(' ');
end

disp(this.filterquantizer,25);

% [EOF]
