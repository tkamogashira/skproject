function blocks = dsp_links(sys)
% DSP_LINKS Display and return library link information
%    for blocks linked to the DSP System Toolbox libraries.
%
%    dsp_links() returns a structure with three elements. Each
%    element contains a cell array of strings containing names
%    of library blocks in the current system. The blocks are grouped into
%    three categories: obsolete, deprecated and current.
%
%    dsp_links(sys) works as above on the named system, instead of gcs.
%
%    Obsolete blocks are blocks that are no longer supported. They
%    might or might not work properly.
%
%    Deprecated blocks are still supported but are likely to be obsoleted in a
%    future release.
%
%    Current blocks are supported and represent the latest block functionality.
%
%    See also LIBLINKS.
%

% Copyright 1995-2011 The MathWorks, Inc.

if nargin==0
    if (isempty(gcs))
        error(message('dsp:dsp_links:noMdlExists'));
    else
        sys=gcs;
        all_dsplibs = dspliblist;
        blocks.obsolete   = liblinks(all_dsplibs.obsolete,   sys);
        blocks.deprecated = liblinks(all_dsplibs.deprecated, sys);
        blocks.current    = liblinks(all_dsplibs.current,    sys);
    end
else    % SYS is specified
    if ~ischar(sys)
        error(message('dsp:dsp_links:notChar'));
    else
        if ~(exist(sys, 'file')==4)
            error(message('dsp:dsp_links:mdlExist', sys));
        else
            % The function 'libinfo' must work on a loaded system, so ensure
            % that the model is loaded.
            wasLoaded = true;
            if ~bdIsLoaded(sys)
                wasLoaded = false;
                load_system(sys);
            end
            all_dsplibs = dspliblist;
            try
                blocks.obsolete   = liblinks(all_dsplibs.obsolete,   sys);
                blocks.deprecated = liblinks(all_dsplibs.deprecated, sys);
                blocks.current    = liblinks(all_dsplibs.current,    sys);
            catch ME
                % error reported by liblinks.
                error(message('dsp:dsp_links:liblinksErr', ME.message));
            end
            
            if ~wasLoaded
                bdclose(sys);
            end
        end
    end
end

% [EOF]
