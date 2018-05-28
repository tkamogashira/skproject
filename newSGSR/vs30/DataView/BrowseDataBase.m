function y = BrowseDataBase(keyword, varargin)
% BrowseDataBase - database functionalities for browsing datasets
%    See also databrowse
global BrowseData
MaxWidth = 120; % max # chars of BrowseData string

% disp(['--------------------' keyword]);
switch keyword
    case 'init' % initialize BrowseData from log file
        if nargin < 3
            showMode = 'spiffy'; 
        else
            showMode = varargin{2}; 
        end
        BrowseDataBase clear; % clear existing BrowseData global
        DF = varargin{1}; % name of experiment ('datafile')
        BrowseData.Experiment = DF;
        BrowseData.DFinfo = ParseLogFile(DF);
        [dum PF] = strtok(BrowseData.DFinfo.StartDate,':');
        PF = strSubst(PF(2:end),' ','_');
        BrowseData.ExpID = [DF PF]; % unique identifier of experiment
        BrowseData.IDstr = localDFinfo2IDstr(BrowseData.DFinfo); % convert to cellstr for display
        if ismember(showMode, {'spiffy', 'classic'})
            BrowseData.showMode = showMode;
        else
            BrowseData.showMode = 'classic';
        end
        % initialize detailed info (empty as yet)
        Ninfo = length(BrowseData.IDstr);
        [BrowseData.PresStr{1:Ninfo,1}] = deal('');
        [BrowseData.ChanStr{1:Ninfo,1}] = deal('');
        [BrowseData.XvalStr{1:Ninfo,1}] = deal('');
        BrowseData.DetailStr = cell(Ninfo, 7);
        [BrowseData.DetailStr{:}] = deal('');
    case 'clear' % clear current BrowseData
        BrowseData = [];
    case 'emptycache' % clear relevant cache files
        if ~isempty(BrowseData)
            EmptyCacheFile dataset;
            FN = FullFileName(BrowseData.ExpID, databrowseDir, 'databrowse');
            EmptyCacheFile(FN);
        end
    case 'save' % save database to file, if any
        if ~isempty(BrowseData)
            FN = FullFileName(BrowseData.ExpID, databrowseDir, 'databrowse');
            % BrowseData.DetailStr
            save(FN, 'BrowseData');
        end
    case {'load', 'update'} % try to load database from file - init if not present in databrowse file
        if nargin<3
            showMode = 'spiffy'; 
        else
            showMode = varargin{2}; 
        end
        if nargin>1
            DF = varargin{1}; % name of experiment ('datafile')
        else% update call
            BrowseDataBase save; % make sure current settings are saved
            DF = BrowseData.Experiment;
        end
        BrowseDataBase('init', DF, showMode);
        FN = FullFileName(BrowseData.ExpID, databrowseDir, 'databrowse');
        if exist(FN,'file')
            qq = load(FN,'-mat');
            if isfield(qq.BrowseData, 'InfoStr') % replace ackward, obsolete, fieldname
                qq.BrowseData.IDstr = qq.BrowseData.InfoStr;
                qq.BrowseData = rmfield(qq.BrowseData,'InfoStr');
            end
            BrowseData = localMergeBD(BrowseData, qq.BrowseData);
        end
    case 'count' % return number of datasets in current database
        y = length(BrowseData.IDstr);
    case 'show' % display all known info of datasets
        uih = varargin{1}; % handle of uicontrol to which to display IDstr
        % cat generic info and details, i.e., IDstr & PresStr ...
        if BrowseData.DFinfo.Nseq==0
            TT = '  --- empty datafile ---';
        elseif isequal('classic', BrowseData.showMode)
            TT = cellstr([char(BrowseData.IDstr) ...
                char(BrowseData.XvalStr) ...
                char(BrowseData.PresStr) ...
                char(BrowseData.ChanStr) ...
                ]);
        elseif isequal('spiffy', BrowseData.showMode)
            NN = size(BrowseData.IDstr,1);
            TT = [char(BrowseData.IDstr) repmat(' ', NN,1)];
            for icol = 3:size(BrowseData.DetailStr,2)
                TT = [TT char(BrowseData.DetailStr(:,icol))];
            end
            TT = cellstr(TT);
            %set(uih, 'fontsize', 6); % 'fontname', 'courier',
        end
        setstring(uih, TT);
    case 'getset'
        if BrowseData.DFinfo.Nseq==0
            return; 
        end
        iset = varargin{1}; % index of dataset within BrowsData. Note: not the same as iseq!
        if ischar(iset)
            iset = str2num(iset); 
        end
        iseq = str2num(BrowseData.DFinfo.Seqs(iset).iseq);
        DS = dataset([bdataDir '\' BrowseData.Experiment], iseq);
        XU = DS.xunit; ttt=findstr(XU,'\mu'); 
        if ~isempty(ttt)
            XU(ttt+[0 1])=''; 
        end
        % collect specific info of this dataset
        BrowseData.PresStr{iset} = ['  ' DS.pres];
        BrowseData.ChanStr{iset} = ['  ' channelChar(DS.chan)];
        BrowseData.XvalStr{iset} = ...
            ['  ' num2sstr(min(DS.xval)) '..' num2sstr(max(DS.xval)) ' ' XU];
        curDS(DS); % set "current" dataset
        [BrowseData.DetailStr(iset,:)] = DSinfoString(DS);
end

%--------------------------------------------
function [IDstr, width] = localDFinfo2IDstr(DFinfo);
% convert DFinfo to cell string
Nseq = DFinfo.Nseq;
if Nseq==0,
    [IDstr, width] = deal(' ',1);
    return;
end
Sep = repmat(' ', Nseq, 2); % whitespace separating the columns
Col_iseq = char({DFinfo.Seqs.iseq}');
Col_ID = char({DFinfo.Seqs.ID}');
IDstr = cellstr([Col_iseq, Sep, Col_ID]);
width = size(IDstr,2);

function newBD = localMergeBD(BD, oldBD);
newBD = combineStruct(oldBD, BD);
%fieldnames(BD), fieldnames(oldBD)
%isequal(sort(fieldnames(BD)), sort(fieldnames(oldBD)))
if ~isequal(sort(fieldnames(BD)), sort(fieldnames(oldBD))), return; end
% BD, oldBD
Nseq = BD.DFinfo.Nseq;
oldNseq = oldBD.DFinfo.Nseq;
fns = fieldnames(newBD);
for ii=1:length(fns),
    fn = fns{ii};
    if iscell(getfield(newBD, fn)),
        % fill old entries with info from oldBD
        if ~isequal(0,oldNseq),
            if isfield(oldBD, fn),
                cmd = ['newBD.' fn '(1:oldNseq,:) = oldBD.' fn '(1:oldNseq,:);'];
                eval(cmd);
            end
        end
    end
end


