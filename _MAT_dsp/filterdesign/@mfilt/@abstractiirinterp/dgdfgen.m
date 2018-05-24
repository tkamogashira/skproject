function msg = dgdfgen(Hd, hTar, doMapCoeffsToPorts, pos)
%DGDFGEN   

%   Author(s): V. Pellissier, U. Biswas
%   Copyright 2004-2010 The MathWorks, Inc.

error(nargchk(3,4,nargin,'struct'));

sys = hTar.system;

t=regexp(sys, '/'); % to get the system and the block %

% Find out if a block with the same name already exist
h= find_system(sys(1:t(end)-1),'Searchdepth',1,'LookUnderMasks','all','Name', sys(t(end)+1:end));

% checks to see whether the FILTER blk needs to be redrawn
[redraw,h] = chkIfRedrawNecessary(Hd,h,sys,'mfilt.abstractiirinterp','InterpolationFactor');

p = positions;
interp_order = Hd.InterpolationFactor;

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
    [hndl,hndl1] = hTar.inport(blk,'');
    pos = p.input + offset;
    set_param([sys '/' blk], 'Position',pos);

end

blk = 'Input';
last_conn{1,1} = [blk '/1'];

set_param(sys, 'UserDataPersistent', 'on'); % update the UserData with the current Filter object.

% store filter and mapcoeffstoports information
CurrentFilter.filter = 'mfilt.abstractiirinterp';
CurrentFilter.RateChangeFactor = Hd.InterpolationFactor;
CurrentFilter.mapcoeffstoports = hTar.MapCoeffsToPorts;
set_param(sys,'UserData',CurrentFilter);

% Sections
nsections = length(Hd.privphase);
for k=1:nsections,
    
    % Force sys to be the current system
    idx = findstr(sys, '/');
    set_param(0,'CurrentSystem',sys(1:idx(end)-1));

    % Add new subsystem for filter realization:
    section_name = ['Phase', sprintf('%d',k)];
    hTarSection =copy(hTar);
    hTarSection.destination = 'current';
    hTarSection.CoeffNames = [];
    idx = findstr(sys, '/');
    if length(idx)==1,
        blockpath = hTar.blockname;
    else
        blockpath = sys(idx(end)+1:end);
    end
    hTarSection.blockname = [blockpath '/' section_name];
    
    % Set parameter for each section
    if doMapCoeffsToPorts
        hTarSection.CoeffNames = hTar.CoeffNames.(sprintf('Phase%d',k));
        coeffvar = hTar.privCoefficients.(sprintf('Phase%d',k));
        setprivcoefficients(hTarSection,coeffvar);
    end
    
    % Obtain state information for each stage
    hTarSection = parse_filterstates(Hd.privphase(k),hTarSection);
        
    % Specify subsystem
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

    % Determine horizontal and vertical offset for rendering filter stage:
    [x_offset, y_offset] = lcloffset(k);
    offset = [x_offset, y_offset, x_offset, y_offset];
    pos = p.section + offset;
    set_param(subsys,'Position', pos);
    new_conn{1,1} = [section_name '/1'];
    
    if redraw
    interstg(hTar, last_conn, new_conn);
    end
    section_conn{1,k} = [section_name '/1'];
end

% Commutator
[x_offset, y_offset] = lcloffset(1);
offset = [x_offset, y_offset, x_offset, y_offset];

interpblk = 'InterpCommutator';

for k = 1:interp_order
    interp_conn{1,k} = [interpblk '/' num2str(k)];
end

if redraw
    hndl = hTar.interpcommutator(interpblk,interp_order,'double',dspblklibname);
    pos = p.interpcomm + offset;
    set_param([sys '/' interpblk], 'Position',pos);

    % Connect input to this stage:
    interstg(hTar, section_conn,interp_conn);

    % Determine horizontal and vertical offset for output:
    [x_offset, y_offset] = lcloffset(1);
    offset = [x_offset, y_offset, x_offset, y_offset];
    p = positions;

    % Output:
    blk = 'Output';
    outport(hTar, blk);
    set_param([sys '/' blk], 'Position', p.output + offset);

    % Connect last stage to output:
    add_line(sys, [interpblk '/1'], [blk '/1'],'autorouting','on');
end


% --------------------------------------------------------------
%                 Utility functions
% --------------------------------------------------------------
function [x_offset, y_offset] = lcloffset(stage)

x_offset = 0;
y_offset = 120*stage-120;

% --------------------------------------------------------------
function p = positions

p.input     = [90, 52, 120, 67];
p.section   = [230, 50, 290, 130];
p.sum       = [280, 47, 305, 72];
p.output    = [380, 132, 410, 147];
p.interpcomm = [320, 40, 350, 240];


% [EOF]
