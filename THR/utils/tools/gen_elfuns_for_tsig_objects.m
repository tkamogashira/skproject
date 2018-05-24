function gen_elfuns_for_tsig_objects;
% gen_elfuns_for_tsig_objects - generate elfuns for tsig objects

qq=what('elfun');
Names = strrep(qq(1).m, '.m', '');

mDir = fullfile(versiondir, 'sig\sig_elfun\@tsig')

for ii=1:length(Names),
    nam = Names{ii};
    L{1,1} = ['function P = ' nam '(P, varargin);'];
    L{2,1} = ['% tsig/' nam ' - ' upper(nam) ' for tsig objects.'];
    L{3,1} = ['% '];
    L{4,1} = ['% See also tsig.'];
    L{5,1} = ['% '];
    L{6,1} = ['for ii=1:nchan(P),'];
    L{7,1} = ['    P.Waveform{ii} = feval(@' nam  ', P.Waveform{ii}, varargin{:});'];
    L{8,1} = ['end;'];
    L{9,1} = [' '];
    %strvcat(L{:})
    FN = fullfilename(nam, mDir, '.m')
    textwrite(FN, L, '-overwrite');
end






