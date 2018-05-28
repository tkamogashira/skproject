function p = RPvdSpath(p, flag);
% RPvdSpath - get/set path for RPvdS circuits
%   RPvdSpath returns current path for RPvdS circuits.
%
%   RPvdSpath(P) sets the path to P. P must be semicolon-separated list of
%   existing directories.
%
%   RPvdSpath(P, '-append') appends P to existing path.
%
%   RPvdSpath(P, '-prepend') prepends P to existing path.
%
%   RPvdSpath('-factory') sets P to its factory default.
%
%   See also sys3loadCircuit, sys3setup, genpath.

if nargin<2, flag=''; end

if nargin<1, % get
    p = sys3setup('COFpath');
else, % set/append or prepend
    if isequal('-factory', p),
        sys3setup COFpath -factory;
        p = sys3setup('COFpath');
        return
    end
    % check existence of new dirs
    [L, N] = words2cell(p,';');
    for ii=1:N,
        if ~exist(L{ii}, 'dir'), 
            error(['Directory ''' L{ii} ''' does not exist.']);
        end
    end
    if isequal('-append', lower(flag)),
        p_old = sys3setup('COFpath');
        p = [p_old ';' p];
    elseif isequal('-prepend', lower(flag)),
        p_old = sys3setup('COFpath');
        p = [p ';' p_old];
    elseif ~isequal('', flag),
        error(['invalid option ''' flag '''.']);
    end
    p = strrep(p,';;', ';');
    sys3setup('COFpath', p);
end








