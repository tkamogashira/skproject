function gen_elfuns_for_playlist_objects;
% gen_elfuns_for_playlist_objects - generate elfuns for playlist objects

qq=what('elfun');
Names = strrep(qq(1).m, '.m', '');

mDir = fullfile(versiondir, 'sig\sig_elfun\@playlist')

for ii=1:length(Names),
    nam = Names{ii};
    L{1,1} = ['function P = ' nam '(P, varargin);'];
    L{2,1} = ['% playlist/' nam ' - ' upper(nam) ' for playlist objects.'];
    L{3,1} = ['% '];
    L{4,1} = ['% See also playlist.'];
    L{5,1} = ['% '];
    L{6,1} = ['for ii=1:nwave(P),'];
    L{7,1} = ['    P.Waveform{ii} = feval(@' nam  ', P.Waveform{ii}, varargin{:});'];
    L{8,1} = ['end;'];
    L{9,1} = [' '];
    %strvcat(L{:})
    FN = fullfilename(nam, mDir, '.m')
    textwrite(FN, L, '-overwrite');
end


% function P = real(P)
% % playlist/real - REAL for playlist objects.
% %
% %   See playlist.
% 
% P.Waveform = cellfun(@real, P.Waveform, 'UniformOutput', false);





