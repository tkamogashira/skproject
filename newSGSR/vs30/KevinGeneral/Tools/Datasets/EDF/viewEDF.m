function ArgOut = viewEDF(FileName)
%VIEWEDF view listing of EDF datafile
%   VIEWEDF(FN) lists all datasets and their stimulus properties for EDF datafile with name FN.
%
%   See also EDFDATASET, EDF2LUT

%B. Van de Sande 11-04-2005

if nargin ~= 1
    error('Wrong number of input arguments.');
end

[FullFileName, FileName] = parseEDFFileName(FileName);
if ~exist(FullFileName, 'file')
    error('First argument should be name of EDF.');
end

SearchParam = dir(FullFileName);
Data = FromCacheFile(mfilename, SearchParam);
if isempty(Data)
    [LUT, HDR] = EDF2LUT(FileName);
    
    fid = fopen(FullFileName, 'r', 'ieee-le');
    if fid == -1
        error('Couldn''t open file %s.', FullFileName);
    end
    
    Hdl = waitbar(0, sprintf('Assembling overview of %s ...', FileName), ...
        'Name', 'viewEDF');
    
    DsLoc = cat(2, LUT.DsLoc);
    NEntries = length(LUT);
    for n = 1:NEntries,
        LST(n).SeqNr   = LUT(n).iSeq;
        LST(n).IDStr   = LUT(n).IDstr;
        LST(n).ExpType = LUT(n).ExpType;
        if ~all(isnan(LUT(n).RecTime))
            LST(n).RecTime = datestr(LUT(n).RecTime, 0);
        else
            LST(n).RecTime = 'N/A';
        end
        
        DsHdr = readEDFDsHeader(fid, DsLoc(n));
        if ~strcmpi(DsHdr.DsID, LUT(n).IDstr) || ...
                ~strcmpi(DsHdr.ExpType, LUT(n).ExpType) || ...
                ~strcmpi(DsHdr.SchName, LUT(n).SchName)
            delete(Hdl);
            error(['Incompatibility between directory entry and dataset ' ...
                'header for dataset with ID %s in EDF %s.'], ...
                LUT(n).IDstr, FileName);
        end
        [DsData, Err] = readEDFDsData(fid, DsLoc(n), LUT(n).SchName);
        switch Err
        case 1
            warning(['Dataset with ID %s in EDF %s has %s as schema type. ' ...
                'This type of schema is not yet implemented.'], ...
                LUT(n).IDstr, FileName, LUT(n).SchName); 

            LST(n).Xname = 'unknown schema';
            [LST(n).Xrange, LST(n).Xscale, LST(n).Xinc, LST(n).Yname, ...
                LST(n).Yrange, LST(n).Yscale, LST(n).Yinc, LST(n).StimType] = ...
                deal('');
            [LST(n).NrDSS, LST(n).MstDSS, LST(n).Nreps, LST(n).BurstDur, ...
                LST(n).RepInt] = deal(NaN);
        case 2
            warning(['Error while trying to read schema type %s from dataset ' ...
                'with ID %s in EDF %s.'], LUT(n).SchName, LUT(n).IDstr, FileName);

            LST(n).Xname = 'corrupted schema';
            [LST(n).Xrange, LST(n).Xscale, LST(n).Xinc, LST(n).Yname, ...
                LST(n).Yrange, LST(n).Yscale, LST(n).Yinc, LST(n).StimType] = ...
                deal('');
            [LST(n).NrDSS, LST(n).MstDSS, LST(n).Nreps, LST(n).BurstDur, ...
                LST(n).RepInt] = deal(NaN);
        case 0
            SchData = structcat(DsHdr, DsData);
            
            if strcmp(LUT(n).SchName, 'calib')
                IndepVarParam = extractSCHIndepVarParam(SchData);
                
                LST(n).Xname    = IndepVarParam(1).ShortName;
                LST(n).Xrange   = getRange(IndepVarParam(1));
                LST(n).Xscale   = IndepVarParam(1).PlotScale;
                LST(n).Xinc     = getInc(IndepVarParam(1));
                [LST(n).Yname, LST(n).Yrange, LST(n).Yscale, LST(n).Yinc] = ...
                    deal('');
                
                LST(n).StimType = '';
                LST(n).NrDSS    = NaN;
                LST(n).MstDSS   = SchData.DSSN;
                LST(n).Nreps    = NaN;
                LST(n).BurstDur = NaN;
                LST(n).RepInt   = NaN;
            elseif strcmp(LUT(n).SchName, 'sch005')
                GenWaveFormParam = extractSCHGenWaveFormParam(SchData);
                IndepVarParam    = extractSCHIndepVarParam(SchData);
                Duration         = calcGEWAVDuration(GenWaveFormParam); %In milliseconds ...
                
                LST(n).Xname    = IndepVarParam(1).ShortName;
                LST(n).Xrange   = getRange(IndepVarParam(1));
                LST(n).Xscale   = IndepVarParam(1).PlotScale;
                LST(n).Xinc     = getInc(IndepVarParam(1));
                [LST(n).Yname, LST(n).Yrange, LST(n).Yscale, LST(n).Yinc] = ...
                    deal('');
                
                LST(n).StimType = '';
                LST(n).NrDSS    = NaN;
                LST(n).MstDSS   = NaN;
                LST(n).Nreps    = 1;
                LST(n).BurstDur = Duration;
                LST(n).RepInt   = Duration;
            elseif any(strcmp(LUT(n).SchName, ...
                    {'sch006', 'sch008', 'sch012', 'sch016'}))
                DSSParam      = extractSCHDSSParam(SchData);
                NRep          = extractSCHNrep(SchData);
                IndepVarParam = extractSCHIndepVarParam(SchData, DSSParam);
                NVar          = length(IndepVarParam);
                GenStimParam  = extractSCHGenStimParam(SchData, DSSParam);
                
                LST(n).Xname    = IndepVarParam(1).ShortName;
                LST(n).Xrange   = getRange(IndepVarParam(1));
                LST(n).Xscale   = IndepVarParam(1).PlotScale;
                LST(n).Xinc     = getInc(IndepVarParam(1));
                if NVar > 1
                    LST(n).Yname  = IndepVarParam(2).ShortName;
                    LST(n).Yrange = getRange(IndepVarParam(2));
                    LST(n).Yscale = IndepVarParam(2).PlotScale;
                    LST(n).Yinc   = getInc(IndepVarParam(2));
                else
                    [LST(n).Yname, LST(n).Yrange, LST(n).Yscale, LST(n).Yinc] = ...
                        deal('');
                end
                
                if DSSParam.Nr > 1
                    LST(n).StimType = ...
                        sprintf('%s/%s', DSSParam.MasterMode, DSSParam.SlaveMode);
                else
                    LST(n).StimType = sprintf('%s', DSSParam.MasterMode);
                end
                LST(n).NrDSS    = DSSParam.Nr;
                LST(n).MstDSS   = DSSParam.MasterNr;
                
                LST(n).Nreps    = NRep;
                
                if DSSParam.Nr > 1
                    LST(n).BurstDur = sprintf('%.0f/%.0f', GenStimParam.BurstDur);
                    LST(n).RepInt   = sprintf('%.0f/%.0f', GenStimParam.RepDur);
                else
                    LST(n).BurstDur = sprintf('%.0f', GenStimParam.BurstDur);
                    LST(n).RepInt   = sprintf('%.0f', GenStimParam.RepDur);
                end    
            else %Schema name not yet implemented in VIEWEDF.M ...
                LST(n).Xname = 'unknown schema';
                [LST(n).Xrange, LST(n).Xscale, LST(n).Xinc, LST(n).Yname, ...
                    LST(n).Yrange, LST(n).Yscale, LST(n).Yinc, ...
                    LST(n).StimType] = deal('');
                [LST(n).NrDSS, LST(n).MstDSS, LST(n).Nreps, LST(n).BurstDur, ...
                    LST(n).RepInt] = deal(NaN);
            end
        end
        
        if ishandle(Hdl)
            waitbar(n/NEntries, Hdl); 
        else
            fclose(fid);
            return
        end
    end
    
    delete(Hdl);
    fclose(fid);
    
    ToCacheFile(mfilename, +100, SearchParam, LST);
else
    LST = Data;
end
    
structview(LST, 'titletxt', ['viewEDF: Overview of ', FileName, '.']);

if nargout == 1
    ArgOut = LST;
end

%-----------------------------------------------local functions--------------------------------------------------
function s = getRange(IndepVarParam)

if length(IndepVarParam.Values) > 1
    s = sprintf('%.0f/%.0f', min(IndepVarParam.Values(:)), max(IndepVarParam.Values(:)));
else
    s = sprintf('%.0f', IndepVarParam.Values(1));
end

function s = getInc(IndepVarParam)

if strcmp(IndepVarParam.PlotScale, 'linear') && (length(IndepVarParam.Values) > 1)
    s = sprintf('%.2f', diff(IndepVarParam(1).Values([1 2])));
elseif strcmp(IndepVarParam.PlotScale, 'linear') && (length(IndepVarParam.Values) == 1)
    s = '0.00';
elseif length(IndepVarParam.Values) > 1
    s = sprintf('%.2f', log2(IndepVarParam.Values(2)/IndepVarParam.Values(1))); 
else
    s = '0.00';
end    
