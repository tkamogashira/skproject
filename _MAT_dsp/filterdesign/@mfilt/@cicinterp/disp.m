function disp(this)
%DISP   Display this object.

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

fn = fieldnames(this);
idx = [3 7 5 6 8];

% Reorder the fields States and InputOffset.
ispersistent = this.PersistentMemory;
if ispersistent,
    idx = [idx 1 4];
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

if ispersistent
    snew = strrep(snew, sprintf('[1x%d filtstates.cic]', length(this.States)), ...
        dispstr(this.States, 31));
end

disp(snew(1:end-1))

if strcmpi(get(0, 'formatspacing'), 'loose')
    disp(' ');
end

disp(this.filterquantizer,23);

% [EOF]
