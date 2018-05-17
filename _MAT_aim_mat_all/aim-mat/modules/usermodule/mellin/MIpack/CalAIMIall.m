
%
%   Calculation of all of AIMI: NAP-SAI-MI
%   IRINO T
%   9 Oct 2002 
%
% function [MI3d, StrobeInfo, NAPparam, STBparam, SAIparam, MIparam] = ...
%          CalAIMIall(Snd,fs,NAPparam,STBparam,SAIparam,MIparam,SwSave);
%
%	INPUT:  Snd : sound for MI
%               fs:   sampling rate 
%               NAPparam,STBparam,SAIparam,MIparam : parameters
%		NameMI: Name of save file. if empty : No save
%
function [MI3d, StrobeInfo, NAPparam, STBparam, SAIparam, MIparam] = ...
   CalAIMIall(Snd,fs,NAPparam,STBparam,SAIparam,MIparam,NameMI);

if nargin < 3, NAPparam = []; end;
if nargin < 4, STBparam = []; end;
if nargin < 5, SAIparam = []; end;
if nargin < 6, MIparam  = []; end;
if nargin < 7, NameMI   = []; end;

if isfield(NAPparam,'fs') == 0, NAPparam.fs = [];  end;
if length(NAPparam.fs) == 0,  NAPparam.fs  = fs; end;
if NAPparam.fs ~= fs,  error('Sampling rate is inconsistent.'); end;

% NAPparam = [];
% NAPparam.fs = fs;               

%%%%%%%%%%%%% CHANGED FROM COMMENTED OUT %%%%%%%%%%%%%%
NAPparam.NumCh   = 75;          % default was 75

% NAPparam.cf_afb  = [100 6000];  % default
NAPparam.SubBase = 0.5;         

if isfield(STBparam,'StInfo_EventLoc') == 0, 
  STBparam.StInfo_EventLoc = []; 
end;

% SAIparam.Nwidth =  -5;          % default
% SAIparam.Pwidth =  15;          % default
SAIparam.FrstepAID = 0;           % Event Synchronous
% SAIparam.ImageDecay = 10;       % SAI image decay / Switch of window function
SAIparam.ImageDecay = 0;          % using Window function
SAIparam.SwSmthWin  = 1;          % Window shape #1

% MIparam.F0mode  = 300;          % default
% MIparam.TFval   = [0:0.25:5];   % default
% MIparam.c_2pi   = [0:0.25:20];  % default
MIparam.Mu        = -0.5; 	  % pre-emphasis of high freq. 

LenSnd = length(Snd);
% disp([NameFile ' : T= ' num2str(LenSnd/NAPparam.fs, 4) ' (sec)']);

[NAP,   NAPparam] 	          = CalNAPghll(Snd,NAPparam);
% PlaySound(Snd,NAPparam.fs);

load C:\MATLAB6p5\work\napat.mat;
NAP=napat;

[NAPPhsCmp, StrobeInfo, STBparam] = CalStrobePoint(NAP,NAPparam,STBparam);

if length(STBparam.StInfo_EventLoc) > 0 
   disp('StrobeInfo.EventLoc is replaced by STBparam.StInfo_EventLoc' )
   disp([ length(StrobeInfo.EventLoc),  length(STBparam.StInfo_EventLoc) ])
   StrobeInfo.NAPpoint = [];
   StrobeInfo.EventLoc = STBparam.StInfo_EventLoc;
end;
[SAI3d, RAI3d, SAIparam, StrobeInfo]  = ...
     CalSAIstinfo(NAPPhsCmp,NAPparam,StrobeInfo,STBparam,SAIparam);

 savefile = 'Irino_SAI.mat';
 save(savefile,'SAI3d');
 
[MI3d, MIparam]           = CalMI(SAI3d,NAPparam,SAIparam,MIparam);

if length(NameMI) > 0,
  str = ['save ' NameMI ' MI3d StrobeInfo ' ...
		   ' NAPparam STBparam SAIparam MIparam ; '];
  disp(str); eval(str);
end;
