function msg = dgdfgen(Hd, hTar, doMapCoeffsToPorts, pos)
%DGDFGEN   

%   Author(s): V. Pellissier, Honglei Chen, Urmi Biswas
%   Copyright 2004-2010 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

sys = hTar.system;
redraw=true; % this flag indicates whether Filter block has to be redrawn or not

t=regexp(sys, '/'); % to get the system and the block %

last_filter=[];

% Find out if a block with the same name already exist
h= find_system(sys(1:t(end)-1),'Searchdepth',1,'LookUnderMasks','all','Name', sys(t(end)+1:end));

% checks to see whether the FILTER blk needs to be redrawn
[redraw,h] = chkIfRedrawNecessary(Hd,h,sys,'mfilt.abstractiirdecim','DecimationFactor');

p = positions;
decim_order = Hd.DecimationFactor;

if strcmp(hTar.Overwrite,'off') || (strcmp(hTar.Overwrite,'on') && isempty(h)) || redraw

    hsubsys = add_block('built-in/subsystem',hTar.system, 'Tag', 'FilterWizardSubSystem');
    % Restore position of the block
    set_param(hsubsys,'Position', pos);

    % Determine horizontal and vertical offset for input:
    [x_offset, y_offset] = lcloffset(1);
    offset = [x_offset, y_offset, x_offset, y_offset];

    % check if dspblks lib is available, if not, load it.
    isdspblkloaded = 0;
    dspblklibname = 'dspsigops';
    spblks_avail = isspblksinstalled;
    if spblks_avail,
        wdspblk = warning;
        warning('off');
        if isempty(find_system(0,'flat','Name',dspblklibname))
            isdspblkloaded = 1;
            load_system(dspblklibname);
        end
        warning(wdspblk);
    end

    % Input:
    blk = 'Input';
    [hndl,hndl1]= hTar.inport(blk, '');
    pos = p.input + offset;
    set_param([sys '/' blk], 'Position',pos);

end

blk = 'Input';

set_param(sys, 'UserDataPersistent', 'on'); % update the UserData with the current Filter object.

% store filter and mapcoeffstoports information
CurrentFilter.filter = 'mfilt.abstractiirdecim';
CurrentFilter.RateChangeFactor = Hd.DecimationFactor;
CurrentFilter.mapcoeffstoports = hTar.MapCoeffsToPorts;
set_param(sys,'UserData',CurrentFilter);

% Commutator
decimblk = 'DecimCommutator';

if redraw
    hndl = hTar.decimcommutator(decimblk,decim_order,'double',dspblklibname);
    pos = p.decimcomm + offset;
    set_param([sys '/' decimblk], 'Position',pos);
    add_line(sys, [blk '/1'], [decimblk '/1'],'autorouting','on');
end


last_conn{1,2} = '';

% Sections
nsections = length(Hd.privphase);
for k=1:nsections,
        
    % Force sys to be the current system
    idx = findstr(sys, '/');
    set_param(0,'CurrentSystem',sys(1:idx(end)-1));

    % Add new subsystem for filter realization:
    section_name = ['Phase', sprintf('%d',k)];
    hTarSection = copy(hTar);
    hTarSection.destination = 'current';
    hTarSection.CoeffNames = [];
    idx = findstr(sys, '/');
    if length(idx)==1,
        blockpath = hTar.blockname;
    else
        blockpath = sys(idx(end)+1:end);
    end
    
    % Set parameter for each section
    if doMapCoeffsToPorts
        hTarSection.CoeffNames = hTar.CoeffNames.(sprintf('Phase%d',k));
        coeffvar = hTar.privCoefficients.(sprintf('Phase%d',k));
        setprivcoefficients(hTarSection,coeffvar);
    end
    
    % Obtain state information for each stage
    hTarSection = parse_filterstates(Hd.privphase(k),hTarSection);
        
    % Specify subsystem
    hTarSection.blockname = [blockpath '/' section_name];
    pos = createmodel(hTarSection);
    subsys = hTarSection.system;
    
    % Realize this section, changed from multistage.realizemdl
    msg='';
    DGDF = dgdfgen(Hd.privphase(k),hTarSection,doMapCoeffsToPorts);
    DG = expandToDG(DGDF,doMapCoeffsToPorts);

    % Optimisations for this section
    if isfield(get(Hd.privphase(k)), 'Arithmetic'),
        optimize(DG,...
            strcmpi(hTar.optimizeones,'on'),...
            strcmpi(hTar.optimizenegones,'on'),...
            strcmpi(hTar.optimizezeros,'on'),...
            strcmpi(hTar.optimizedelaychains,'on'),...
            strcmpi(hTar.mapcoeffstoports,'on'),...
            Hd.privphase(k).Arithmetic);
    else
        optimize(DG,...
            strcmpi(hTar.optimizeones,'on'),...
            strcmpi(hTar.optimizenegones,'on'),...
            strcmpi(hTar.optimizezeros,'on'),...
            strcmpi(hTar.optimizedelaychains,'on'), ...
            strcmpi(hTar.mapcoeffstoports,'on'),...
            'double');
    end

    % Garbage Collection (clean up)
    DG = gc(DG);

    % generate mdl model
    dg2mdl(DG,hTarSection,pos);
    
    % Determine horizontal and vertical offset for rendering filter Phase:
    [x_offset, y_offset] = lcloffset(k);
    offset = [x_offset, y_offset, x_offset, y_offset];
    pos = p.section + offset;
    set_param(subsys,'Position', pos);
    last_conn{1,1} = [decimblk '/' num2str(k)];
    new_conn{1,1} = [section_name '/1'];
    % Last Phase: no summer - use output of Section block for inter-Phase connections
    new_conn{1,2} = new_conn{1,1};
    
    new_conn{2,2}='';
    if k<nsections,
        % Use a SUMMER :
        if k==1,
            sum_str = '|++';
            orient = 'right';
        else
            sum_str = '++|';
            orient = 'up';
        end
        blk = ['Sum' sprintf('%d', k)];
        ic{k} = blk;
        
        if redraw
            sum(hTar, blk, sum_str, 'double');
            pos = p.sum + offset;
            set_param([sys '/' blk], 'Position', pos, ...
                'Orientation', orient, 'ShowName','off');
            
            % Internal connection:
            add_line(sys, [section_name '/1'], [ic{k} '/1'],'autorouting','on');  % Connect Section subsystem to summer
        end
        
        new_conn{1,2}=[blk '/1'];  % output of the summer
        new_conn{2,2}=[blk '/2'];  % 2nd input of the summer
    elseif k==1,
        ic{1} = section_name;
    end
    
    if redraw
        % Connect input to this Phase:
        interstg(hTar, last_conn,new_conn, [12 21]);
    end
    last_conn{1,2} = new_conn{2,2};
end

% Determine horizontal and vertical offset for output:
[x_offset, y_offset] = lcloffset(1);
offset = [x_offset, y_offset, x_offset, y_offset];
p = positions;

if redraw
    % Gain
    gblk = 'Gain';
    hTar.gain(gblk,num2str(1/decim_order,'%22.18g'),'double');
    set_param([sys '/' gblk], 'Position', p.gain + offset);
    % Connect last Phase to output:
    add_line(sys, [ic{1} '/1'], [gblk '/1'],'autorouting','on');

    
    % Output:
    blk = 'Output';
    outport(hTar, blk);
    set_param([sys '/' blk], 'Position', p.output + offset);
    add_line(sys, [gblk '/1'], [blk '/1'],'autorouting','on');
end


% --------------------------------------------------------------
%                 Utility functions
% --------------------------------------------------------------
function [x_offset, y_offset] = lcloffset(stage)

x_offset = 0;
y_offset = 120*stage-120;

% --------------------------------------------------------------
function p = positions

p.input     = [50, 132, 80, 147];
p.section   = [240, 50, 300, 130];
p.sum       = [350, 47, 375, 72];
p.output    = [510, 52, 540, 67];
p.decimcomm = [100, 40, 130, 240];
p.gain      = [450, 45, 480, 75];


% [EOF]



