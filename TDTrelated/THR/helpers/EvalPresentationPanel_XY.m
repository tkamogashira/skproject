function VO = EvalPresentationPanel_XY(figh, P, Ncond);
% EvalPresentationPanel_XY - stimulus visiting order for two varied params
%   VO = EvalPresentationPanel_XY(figh, P, Ncond) processes the info on 
%   visiting the stimulus condition in the case of two independently varied
%   stimulus parameters. P is the output of GUIval applied to the stimulus
%   GUI having handle figh. The relevant queries in the GUI, which are 
%   provided by PresentationPanel_XY, have resulted in the following fields
%   in P
%         Nrep: Number of repetitions of each stimulsu condition
%        RSeed: Random seed used for random visiting orders
%      Slowest: String identifying the slowest varying stimulus parameter
%     Nextslow: String identifying the 2nd slowest varying stimulus parameter
%      Fastest: String identifying the fastest varying stimulus parameter
%       Xorder: Visiting order for 1st param. One of Forward, Reverse,
%               Random Scrambled. Random means same random order for every
%               rep. Scrambled means a new random order for each rep.
%       Yorder: Visiting order for 1st param.
%        Xname: Name of first parameter. 
%        Yname: Name of second parameter. 
%   Ncond is a 2-element array holding the number of values for X and Y,
%   respectively. Ncond is typically obtained by a call to  MixSweeps in 
%   the stimulus generator makestimXX. See makestimRF for an example.
%   
%   EvalPresentationPanel_XY returns a struct VO in which the visiting
%   order is elaborated.
%
%   See also MixSweeps, makestimRF.

VO = []; % def out arg value allows premature return

% check if the speed buttons contain each of (Rep, X, Y) exactly once.
Speed1 = local_genericnames(P.Slowest, P);
Speed2 = local_genericnames(P.Nextslow, P);
Speed3 = local_genericnames(P.Fastest, P);
AllSpeeds = [Speed3 Speed2 Speed1]; % from fast to slow
fuseXY = ismember('XY', {Speed1 Speed2 Speed3}); % X&Y merged into single pool?
Mess = ''; % 
if ~ismember('X', AllSpeeds),
    Mess = ['Update priority of ' P.Xname ' is missing.'];
elseif ~ismember('Y', AllSpeeds),
    Mess = ['Update priority of ' P.Yname ' is missing.'];
elseif ~ismember('R', AllSpeeds),
    Mess = 'Update priority of Rep is missing.';
elseif numel(findstr('X', AllSpeeds))>1, 
    Mess = [P.Xname ' occurs twice in the update specification.']
elseif numel(findstr('Y', AllSpeeds))>1, 
    Mess = [P.Yname ' occurs twice in the update specification.']
elseif numel(findstr('R', AllSpeeds))>1, 
    Mess = 'Rep occurs twice in the update specification.'
end
if ~isempty(Mess),
    Guimessage(figh, Mess, 'error', {'Slowest' 'Nextslow' 'Fastest'});
    return;
end
if fuseXY && ~isequal('RandomRandom', [P.Xorder P.Yorder]) ...
        && ~isequal('ScrambledScrambled', [P.Xorder P.Yorder]),
    Mess = ['When varying ' P.Xname ' and ' P.Yname ' together,' char(10), ...
        'their visiting orders should both be equal to', char(10), ...
        'either Random or Scrambled.'];
    GUImessage(figh, Mess, 'error', {'Xorder' 'Yorder'});
    return;
end

% ====now the fun starts====
iCond = reshape((1:prod(Ncond)).', Ncond);
iRep = reshape(1:P.Nrep, [1 1 P.Nrep]);
[iCond, iRep] = samesize(iCond, iRep); % X,Y,Rep, in dim 1,2,3.
[sdX, sdY, mayScrambleXY] = deal(nan);
if fuseXY, % effective 2D situation (dims 1&2 fused)
    NewSize = [prod(Ncond) 1 P.Nrep]; % XY, Rep in dim 1,3
    [iCond, iRep] = deal(reshape(iCond,NewSize), reshape(iRep,NewSize));
    if isequal('XYR', AllSpeeds),
        dimSort = [1 2 3]; % iCond(iXY, 1, iRep)
        mayScrambleXY = true;
    elseif isequal('RXY', AllSpeeds),
        dimSort = [3 1 2]; % iCond(iRep, iXY, 1)
        mayScrambleXY = false; % R faster than XY
    end
    iCond = local_orderXY(iCond, P.Xorder, mayScrambleXY);
else,
    dimSort = strrep(AllSpeeds, 'R', 'Z')+1-'X'; % X,Y,R -> 1,2,3
    % each var may only be scrambled in dimensions that are slower than itself 
    ilocx = find(AllSpeeds=='X'); % update speed ranking for X
    ilocy = find(AllSpeeds=='Y'); % update speed ranking for Y
    ilocr = find(AllSpeeds=='R'); % update speed ranking for R
    sdX = []; % scramble dimension for X
    if ilocx<ilocy, sdX = [sdX 2]; end
    if ilocx<ilocr, sdX = [sdX 3]; end
    sdY = []; % scramble dimension for Y
    if ilocy<ilocx, sdY = [sdY 1]; end
    if ilocy<ilocr, sdY = [sdY 3]; end
    iCond = local_orderX(iCond, P.Xorder, sdX);
    iCond = local_orderY(iCond, P.Yorder, sdY);
end

iCond = permute(iCond, dimSort);
iRep = permute(iRep, dimSort);
iX = 1+mod(iCond-1, Ncond(1));
iY = 1+round((iCond-iX)/Ncond(1));
VO = collectInStruct(AllSpeeds, fuseXY, sdX, sdY, mayScrambleXY, '-', ...
    dimSort, iCond, iRep, iX, iY);


%=======================
function Str = local_genericnames(Str,P);
% replace occurrences of P.Xname by 'X', of P.Yname by 'Y', and of 'Rep' by
% 'R', and strip off any '+ and '-' separators.
Str = strrep(Str, P.Xname, 'X');
Str = strrep(Str, P.Yname, 'Y');
Str = strrep(Str, 'Rep', 'R');
Str = strrep(Str, '-', '');
Str = strrep(Str, '+', '');

function iCond = local_orderXY(iCond, Order, doScramble);
% re-order along 1st dim; 3rd dim is Rep count
if ~doScramble && isequal('Scrambled', Order),
    Order = 'Random'; 
end
Nx = size(iCond,1);
Nrep = size(iCond,3);
switch Order,
    case 'Forward', % okay
    case 'Reverse', iCond = flipdim(iCond,1);
    case 'Random',  iCond= iCond(randperm(Nx),:,:);
    case 'Scrambled', 
        for ii=1:Nrep,
            iCond(:,:,ii) = iCond(randperm(Nx),:,ii);
        end
end

function iCond = local_orderX(iCond, Order, sdX);
% re-order along 1st dim
if isempty(sdX) && isequal('Scrambled', Order),
    Order = 'Random'; 
end
[Nx, Ny, Nrep] = size(iCond);
switch Order,
    case 'Forward', % okay
    case 'Reverse', iCond = flipdim(iCond,2);
    case 'Random',  iCond= iCond(randperm(Nx),:,:);
    case 'Scrambled', 
        if isequal(2, sdX);
            for iy=1:Ny,
                iCond(:, iy,:) = iCond(randperm(Nx),iy,:);
            end
        elseif isequal(3, sdX);
            for ir=1:Nrep,
                iCond(:,:,ir) = iCond(randperm(Nx),:,ir);
            end
        else,
            for iy=1:Ny,
                for ir=1:Nrep,
                    iCond(:,iy,ir) = iCond(randperm(Nx),iy,ir);
                end
            end
        end
end

function iCond = local_orderY(iCond, Order, sdY);
% re-order along 2nd dim
if isempty(sdY) && isequal('Scrambled', Order),
    Order = 'Random'; 
end
[Nx, Ny, Nrep] = size(iCond);
switch Order,
    case 'Forward', % okay
    case 'Reverse', iCond = flipdim(iCond,2);
    case 'Random',  iCond= iCond(:, randperm(Ny),:);
    case 'Scrambled', 
        if isequal(1, sdY);
            for ix=1:Nx,
                iCond(ix,:,:) = iCond(ix,randperm(Ny),:);
            end
        elseif isequal(3, sdY);
            for ir=1:Nrep,
                iCond(:,:,ir) = iCond(:,randperm(Ny),ir);
            end
        else,
            for ix=1:Nx,
                for ir=1:Nrep,
                    iCond(ix,:,ir) = iCond(ix,randperm(Ny),ir);
                end
            end
        end
end


function [iCond, iRep] = local_permute(iCond, iRep, Order)
iCond = permute(iCond, Order)
iRep = permute(iRep, Order);

