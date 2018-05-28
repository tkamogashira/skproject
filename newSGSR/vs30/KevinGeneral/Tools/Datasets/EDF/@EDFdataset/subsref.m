function varargout = subsref(ds, S)
%EDFDATASET/SUBSREF - overloaded SUBSREF for EDF dataset objects

%B. Van de Sande 27-05-2004

%% ---------------- CHANGELOG -----------------------
%  Mon Mar 14 2011  Abel   
%   - Removed ErrorOnNewRelease

switch S(1).type
case '()'
    if length(ds) == 1 && ~isequal(S(1).subs, num2cell(ones(1, length(S(1).subs))))
        error('Subscript out of range.');
    elseif length(S) == 1
        varargout{1} = ds(S(1).subs{:});    
    else
        varargout{1} = subsref(ds(S(1).subs{:}), S(2:end));
    end
case '{}', error('Subscripted reference of type {} cannot be used on dataset objects.');
case '.'
    if length(ds) > 1
        %A comma separated list generated without indexing gets returned in reverse order ... Known MATLAB bug in 
        %releases 12 and later, more information can be found at http://www.mathworks.com/support/solutions/data/33496.shtml ... 
    %    ErrorOnNewRelease;
        N = numel(ds);
        for n = 1:N
            varargout{n} = subsref(ds(n), S);
        end
        [varargout{1:N}] = deal(varargout{N:-1:1});
    else
        NVar = length(ds.EDFIndepVar);
        
        if length(S) > 1
            switch lower(S(1).subs)
            case {'spt', 'spiketimes'},
                if length(S(2).subs) > 2
                    error('Invalid syntax.');
                end
                
                switch S(2).type
                case '()',
                    if length(S) == 2, varargout{1} = ds.dataset.Data.SpikeTimes(S(2).subs{:});
                    else, varargout{1} = subsref(ds.dataset.Data.SpikeTimes(S(2).subs{:}), S(3:end)); end    
                case '{}',
                    if length(S) == 2
                        %A comma separated list generated with indexing doesn't return the correct number of outputs,
                        %to be more precise: only one output gets returned! This is a known and uncorrectable MATLAB
                        %bug. For more information see http://www.mathworks.com/support/solutions/data/33501.shtml ...
                        ErrorOnNewRelease;
                        if ~isempty(strfind(cat(2, S(2).subs{:}), ':'))
                            warning(['Object classes in MATLAB which overload '...
                                'subscripted reference cannot implement comma '...
                                'separated lists.\nOnly the first argument is returned.']);
                        end
                        varargout = ds.dataset.Data.SpikeTimes(S(2).subs{:});
                    else
                        varargout{1} = builtin('subsref', ds.dataset.Data.SpikeTimes{S(2).subs{:}}, S(3:end));
                    end
                case '.', error('Invalid syntax.');
                end
            case cellstr(char([repmat('spt', 16, 1), num2str((0:15)', '%-.0f')], [repmat('spiketimes', 16, 1), num2str((0:15)', '%-.0f')])),
                if length(S(2).subs) > 2
                    error('Invalid syntax.');
                end
                if strncmpi(S(1).subs, 'spt', 3)
                    TimerNr = sscanf(lower(S(1).subs), 'spt%d', 1);
                else
                    TimerNr = sscanf(lower(S(1).subs), 'spiketimes%d', 1);
                end
                if ~ismember(TimerNr, ds.TimerNrs)
                    error('Event timer %d wasn''t used.', TimerNr);
                end
                
                switch S(2).type,
                case '()',
                    if length(S) == 2
                        varargout{1} = eval(sprintf('ds.EDFData.SpikeTimes%d(S(2).subs{:});', TimerNr));
                    else
                        varargout{1} = eval(sprintf('subsref(ds.EDFData.SpikeTimes%d(S(2).subs{:}), S(3:end));', TimerNr));
                    end
                case '{}',
                    if length(S) == 2
                        %A comma separated list generated with indexing doesn't return the correct number of outputs,
                        %to be more precise: only one output gets returned! This is a known and uncorrectable MATLAB
                        %bug. For more information see http://www.mathworks.com/support/solutions/data/33501.shtml ...
                        ErrorOnNewRelease;
                        if ~isempty(strfind(cat(2, S(2).subs{:}), ':'))
                            warning('Object classes in MATLAB which overload subscripted reference cannot implement comma separated lists.\nOnly the first argument is returned.');
                        end
                        varargout = eval(sprintf('ds.EDFData.SpikeTimes%d(S(2).subs{:});', TimerNr));
                    else
                        varargout{1} = eval(sprintf('builtin(''subsref'', ds.EDFData.SpikeTimes%d{S(2).subs{:}}, S(3:end));', TimerNr));
                    end
                case '.', error('Invalid syntax.');
                end
            case {'spiketimes3d', 'spt3d'}, 
                if length(S(2).subs) ~= 3
                    error('Invalid syntax.');
                end
                Spt = subsref(ds, struct('type', '.', 'subs', 'spt3d'));
                
                switch S(2).type,
                case '()',
                    if length(S) == 2
                        varargout{1} = Spt(S(2).subs{:});
                    else
                        varargout{1} = subsref(Spt(S(2).subs{:}), S(3:end));
                    end
                case '{}', 
                    if length(S) == 2
                        %Known and uncorrectable MATLAB bug, see above ...
                        ErrorOnNewRelease;
                        if ~isempty(strfind(cat(2, S(2).subs{:}), ':'))
                            warning('Object classes in MATLAB which overload subscripted reference cannot implement comma separated lists.\nOnly the first argument is returned.');
                        end
                        varargout = Spt(S(2).subs{:}); 
                    else
                        varargout{1} = builtin('subsref', Spt{S(2).subs{:}}, S(3:end));
                    end
                case '.',
                    error('Invalid syntax.');
                end
            otherwise,
                varargout{1} = subsref(subsref(ds, S(1)), S(2:end));
            end
        else
            switch lower(S(1).subs),
            case 'help',
                varargout{1} = help('EDFdatasetHelp');
                return;
            %-------------------------------------------------------------------------------------------------------%    
            case 'id',       varargout{1} = structcat(ds.dataset.ID, ds.ID); return;
            case 'exptype',  varargout{1} = ds.dataset.ID.StimType; return;  
            case 'schname',  varargout{1} = ds.ID.SchName; return;
            %-------------------------------------------------------------------------------------------------------%    
            case 'sizes',    varargout{1} = structcat(ds.dataset.Sizes, ds.Sizes); return;
            case 'ntimers',  varargout{1} = ds.Sizes.Ntimers; return;           
            %-------------------------------------------------------------------------------------------------------%    
            case 'timernrs',  varargout{1} = ds.TimerNrs; return;           
            %-------------------------------------------------------------------------------------------------------%    
            case 'dss',      varargout{1} = ds.DSS; return;
            case 'dssnr',    varargout{1} = length(ds.DSS); return;
            case 'mdssnr',   
                if (length(ds.DSS) >= 1), varargout{1} = ds.DSS(1).Nr; return;
                else error('No DSS information in dataset.'); end
            case 'mdssmode', 
                if (length(ds.DSS) >= 1), varargout{1} = ds.DSS(1).Mode; return;
                else error('No DSS information in dataset.'); end
            case 'sdssnr',   
                if (length(ds.DSS) == 2), varargout{1} = ds.DSS(2).Nr; return;
                else error('Slave DSS not used.'); end
            case 'sdssmode', 
                if (length(ds.DSS) == 2), varargout{1} = ds.DSS(2).Mode; return;
                else error('Slave DSS not used.'); end
            %-------------------------------------------------------------------------------------------------------%    
            case 'mgwfile',   
                if isfield(ds.dataset.Stimulus.StimParam, 'GWParam'), 
                    varargout{1} = ds.dataset.Stimulus.StimParam.GWParam.FileName{1}; return;
                else error('No GW information present in dataset.');
                end
            case 'mgwid', 
                if isfield(ds.dataset.Stimulus.StimParam, 'GWParam'), 
                    varargout{1} = ds.dataset.Stimulus.StimParam.GWParam.ID{1}; return;
                else
                    error('No GW information present in dataset.');
                end
            case 'sgwfile',   
                if isfield(ds.dataset.Stimulus.StimParam, 'GWParam') & (length(ds.dataset.Stimulus.StimParam.GWParam.FileName) == 2), 
                    varargout{1} = ds.dataset.Stimulus.StimParam.GWParam.FileName{2}; return;
                else, error('Slave DSS nor used.'); end
            case 'sgwid', 
                if isfield(ds.dataset.Stimulus.StimParam, 'GWParam') & (length(ds.dataset.Stimulus.StimParam.GWParam.ID) == 2),
                    varargout{1} = ds.dataset.Stimulus.StimParam.GWParam.ID{2}; return;
                else, error('Slave DSS nor used.'); end
            %-------------------------------------------------------------------------------------------------------%    
            %Virtual fields that do not specify a specific independent variable, such as 'indepvar' and 'indepval',
            %have a compatible usage with dataset objects. When only one independent variable is present they return
            %information on that variable, but in case there are two independent variables then they return
            %information on the non-existent variable 'Subsequence number'. 'x', 'xval', ... and 'y', 'yval', ...
            %return exact information on the first, respectively the second independent variable.
            %Attention: this approach is not compatible with SGSR tools: 'x' and 'xval' are almost always used in 
            %these programs to retrieve information on the independent variable. So a more compatible approach 
            %would be to make 'x' and 'xval' behave like the aforementioned virtual fields although this is not
            %very consistent with their names. The virtual fields 'indepvar' and 'indepval' can then return cell-
            %array of strings or matrices when used on datasets that have two independent variables ...
            case 'indepnr',  varargout{1} = length(ds.EDFIndepVar); return;
            case {'indep', 'indepvar'}, if NVar == 1, varargout{1} = ds.EDFIndepVar; return; end
            case 'x',        varargout{1} = ds.EDFIndepVar(1); return;
            case 'y',        if NVar == 2, varargout{1} = ds.EDFIndepVar(2); return; else, error('No second independent variable present.'); end    
            case 'indepval', if NVar == 1, varargout{1} = ds.EDFIndepVar(1).Values; return; end
            case 'xval',     varargout{1} = ds.EDFIndepVar(1).Values; return    
            case 'yval',     if NVar == 2, varargout{1} = ds.EDFIndepVar(2).Values; return; else, error('No second independent variable present.'); end    
            case 'indepunit', if NVar == 1, varargout{1} = ds.EDFIndepVar(1).Unit; return; end 
            case 'xunit',    varargout{1} = ds.EDFIndepVar(1).Unit; return;   
            case 'yunit',    if NVar == 2, varargout{1} = ds.EDFIndepVar(2).Unit; return; else, error('No second independent variable present.'); end    
            case 'indepname', if NVar == 1, varargout{1} = ds.EDFIndepVar(1).Name; return; end
            case 'xname',    varargout{1} = ds.EDFIndepVar(1).Name; return;    
            case 'yname',    if NVar == 2, varargout{1} = ds.EDFIndepVar(2).Name; return; else, error('No second independent variable present.'); end    
            case 'indeplabel', if NVar == 1, varargout{1} = [ds.EDFIndepVar(1).Name '(' ds.EDFIndepVar(1).Unit ')' ]; return; end
            case 'xlabel',   varargout{1} = [ds.EDFIndepVar(1).Name '(' ds.EDFIndepVar(1).Unit ')' ]; return;   
            case 'ylabel',   if NVar == 2, varargout{1} = [ds.EDFIndepVar(2).Name '(' ds.EDFIndepVar(2).Unit ')' ]; return; else, error('No second independent variable present.'); end    
            case 'indepshortname', if NVar == 1, varargout{1} = ds.EDFIndepVar(1).ShortName; return; end    
            case 'xshortname', varargout{1} = ds.EDFIndepVar(1).ShortName; return;   
            case 'yshortname', if NVar == 2, varargout{1} = ds.EDFIndepVar(2).ShortName; return; else, error('No second independent variable present.'); end    
            case 'indepscale', if NVar == 1, varargout{1} = ds.EDFIndepVar(1).PlotScale; return; end    
            case {'xplotscale', 'xscale'}, varargout{1} = ds.EDFIndepVar(1).PlotScale; return; 
            case {'yplotscale', 'yscale'}, if NVar == 2, varargout{1} = ds.EDFIndepVar(2).PlotScale; return; else, error('No second independent variable.'); end
            case 'indepval3d', 
                if NVar == 2,
                    %Known and uncorrectable MATLAB bug, see above ...
                    warning(sprintf('Object classes in MATLAB which overload subscripted reference cannot implement comma separated lists.\nOnly the first argument is returned.'));
                    [xval, idx] = unique(ds.EDFIndepVar(1).Values); if all(diff(idx) < 0), xval = xval(end:-1:1); end 
                    [yval, idx] = unique(ds.EDFIndepVar(2).Values); if all(diff(idx) < 0), yval = yval(end:-1:1); end 
                    [varargout{1:2}] = meshgrid(xval, yval); 
                else, varargout{1} = subsref(ds, struct('type', '.', 'subs', 'indepval')); end; 
                return;    
            case 'xval3d', 
                if NVar == 2, 
                    [xval, idx] = unique(ds.EDFIndepVar(1).Values); if all(diff(idx) < 0), xval = xval(end:-1:1); end 
                    [yval, idx] = unique(ds.EDFIndepVar(2).Values); if all(diff(idx) < 0), yval = yval(end:-1:1); end 
                    varargout{1} = meshgrid(xval, yval); 
                else, varargout{1} = subsref(ds, struct('type', '.', 'subs', 'xval')); end; 
                return;
            case 'yval3d', 
                if NVar == 2,
                    [xval, idx] = unique(ds.EDFIndepVar(1).Values); if all(diff(idx) < 0), xval = xval(end:-1:1); end 
                    [yval, idx] = unique(ds.EDFIndepVar(2).Values); if all(diff(idx) < 0), yval = yval(end:-1:1); end 
                    [dummy, varargout{1}] = meshgrid(xval, yval); 
                else, varargout{1} = subsref(ds, struct('type', '.', 'subs', 'yval')); end; 
                return;
            %-------------------------------------------------------------------------------------------------------%    
            case lower(fieldnames(ds)), varargout{1} = eval(sprintf('ds.%s;', S.subs)); return;
            %-------------------------------------------------------------------------------------------------------%    
            case {'spiketimes3d', 'spt3d'},
                if NVar == 2,
                    [nX, nY] = deal(length(unique(ds.IndepVar(1).Values)), length(unique(ds.IndepVar(2).Values)));
                    nRep = ds.dataset.Sizes.Nrep;
                    
                    idx = repmat((1:nY:(nX*nY))', 1, nY) + repmat(0:nY-1, nX, 1);
                    varargout{1} = reshape(ds.dataset.Data.SpikeTimes(idx(:), :), nX, nY, nRep);
                    return;
                else, varargout{1} = ds.dataset.spt; return; end;
            %-------------------------------------------------------------------------------------------------------%    
            case cellstr(char([repmat('spt', 16, 1), num2str((0:15)', '%-.0f')], [repmat('spiketimes', 16, 1), num2str((0:15)', '%-.0f')])),
                if strncmpi(S(1).subs, 'spt', 3), TimerNr = sscanf(lower(S(1).subs), 'spt%d', 1);
                else, TimerNr = sscanf(lower(S(1).subs), 'spiketimes%d', 1); end
                if ~ismember(TimerNr, ds.TimerNrs), error(sprintf('Event timer %d wasn''t used.', TimerNr)); end
                varargout{1} = eval(sprintf('ds.EDFData.SpikeTimes%d', TimerNr));
                return;
            end
            %-------------------------------------------------------------------------------------------------------%    
            varargout{1} = subsref(ds.dataset, S); %Parent class subsref.m ...
        end
    end
end