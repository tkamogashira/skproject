function THR = getThr4D4( ds, ignoreUserData )
% GETTHR4DS - Get the THR for a dataset
%   First getThr4DS tries to retrieve the thrSequence from the userdata, and
%   retrieve the THR from this sequence. If unable to do this, getThr4Cell
%   is used.

% K. Spiritus

if isequal(1, nargin)
    ignoreUserData = 0;
end

if ~ignoreUserData
    try
        UD = getuserdata(ds);
        if isempty(UD)
            error('Userdata is empty');
        end
        if isempty(UD.CellInfo) | isnan(UD.CellInfo.THRSeq)
            error('Problems with cell info in user data');
        end

        dsTHR = dataset(ds.ID.FileName, UD.CellInfo.THRSeq);
        [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        THR = CollectInStruct(CF, SR, Thr, BW, Q10);
        return;
    catch
        warning(sprintf('%s\nAdditional information from SGSR server is not included.', lasterr));
    end
end

% not there yet? try without userdata
ignoreUserData = 1;
slashPos = strfind(ds.ID.FullFileName, '\');
fileName = ds.ID.FullFileName(slashPos(end)+1:end);

THR = getThr4Cell(fileName, ds.ID.iCell, ignoreUserData);