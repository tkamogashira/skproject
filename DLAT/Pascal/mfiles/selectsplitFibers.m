function L = selectsplitFibers(filename, thl, maxthr, splitfreq)

% selectsplitFibers(filename, thl, maxthr, splitfreq)
% Selects the fibers of file filename in thresholdlist thl (from thrlist.m) which have a
% threshold below maxthr (in dB), and splits those fibers in high and low
% frequency (according to splitfreq, in Hz). 
% The result is a struct array with fields filename, fibernr, freqgroup, thr, cf

rows = numel(thl);

L=struct([]);
L(1).filename=NaN;
L(1).fibernr=NaN;
L(1).freqgroup=NaN;
L(1).thr=NaN;
L(1).cf=NaN;

curr=1;

for i=1:rows
    tc=thl(i);
    
    t = extractTHR(tc{1});
    cf = extractCF(tc{1});
    
    if t<=maxthr
        if cf<=splitfreq
            L(curr).filename=filename;
            L(curr).fibernr=extractFNR(tc{1});
            L(curr).freqgroup='lo';
            L(curr).thr=t;
            L(curr).cf=cf;
            curr=curr+1;
        elseif cf>splitfreq
            L(curr).filename=filename;
            L(curr).fibernr=extractFNR(tc{1});
            L(curr).freqgroup='hi';
            L(curr).thr=t;
            L(curr).cf=cf;
            curr=curr+1;
        end
    end
end

%-------------------------local functions-------------------------------------

%These functions extract the threshold, cf and fibernr from a string like this:
%'% 1 --- cell 62 -- 27.8 dB SPL @ 25 kHz  SR = 71 sp/s   <62-1-THR>'


function t = extractTHR(string)

endidx = findstr('dB', string) - 2;
beginidx = findstr('--', string); beginidx = beginidx(3) + 3;
t=str2num(string(beginidx:endidx));

function c = extractCF(string)

endidx = findstr('kHz', string) - 2;
beginidx = findstr('@', string) + 2;
c=str2num(string(beginidx:endidx))*1000; %scale to Hz

function f = extractFNR(string)

endidx = findstr('--', string); endidx = endidx(3) - 2;
beginidx = findstr('cell', string) + 5;
f=str2num(string(beginidx:endidx));