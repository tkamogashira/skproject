% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org


function f=spectrogram(sig,nr_f,maxfre)

nsig=changesr(sig,maxfre*2);
sr=getsr(nsig);
vals=getvalues(nsig);

% sig_len=getlength(sig);
% time_step=sig_len/nr_t;
% window=[0:time_step:sig_len];
% win_len=getnrpoints(nsig)/nr_t;
% window = hann(round(win_len));
% noverlap=round(win_len/2);
noverlap=nr_f*2-2;
[Bb,freqs,ts]=specgram(vals,nr_f*2,sr*2,[],noverlap);

B=Bb(2:nr_f+1,:);

nr_t=size(B,2);
nr_f=size(B,1);

srf=nr_t/getlength(sig);
f=field(nr_t,nr_f,srf);
f=setvalues(f,abs(B));
f=setmaxfre(f,maxfre);

return




% function f=spectrogram(sig,tstart,tstop,nr_t,nr_f,maxfre)
% alle Zeiten in Sekunden
% macht ein Sektrogramm aus dem Signal sig, das zu nr_t Zeiten gesampelt
% wird und nr_f Frequenzen hat
% das Signal wird aus sig in der Zeit von start bis stop genommen
% das Signal sig wird erst so auf eine Samplerate gebracht, dass 
% das Resultat der FFT eine Auflösung bis maxfre hat.

if nargin<6
    maxfre=GetSR(sig)/2;
end

% die alte (orginale) Samplerate
sr_old=GetSR(sig);

%wenn die maxfre anders ist als die, die das Signal mitbringt, dann muss das Signal heruntergesamplet werden:
if sr_old~=maxfre*2
    sr_neu=maxfre*2;
    sig=changesr(sig,sr_neu);   % änder das ganze Signal zu der neuen SR
else 
    sr_neu=sr_old;
end

% Punkte, die die FFT benötigt, damit nr_f punkte hinten raus kommen
nr_fft=nr_f*2;
% und das ist ein Signal von dieser Länge: (auch mit neuer Samplerate)
stime=bin2time(nr_fft,sr_neu);
% Dauer des zu untersuchenden Signals
duration=tstop-tstart;
% wenn die gewünschte Samplingrate nicht hoch genug ist, weil zuviel Punkte erforderlich sind
if duration < stime
    error('spectrogram: desired Samplingrate too low: take less points or higher freqeuncy!');
    return;
end


% meine Notation ist anders als Matlab: Bei mir ist x die Zeit
% und y die Frequenz
sr_field=nr_t/duration; % die "SampleRate" des Feldes (sehr klein, da nur wenig Punkte)
f=field(nr_t,nr_f,sr_field);
f=setmaxfre(f,maxfre);  % Für die Grafik: Wie hoch die Frequenzen geben

% damit die fft immer von einem richtigen vollen Signal gemacht werden kann, werden die 
% FFTs an Stellen berechenet, die immer ein volles signal haben
time_step=(tstop-tstart-stime)/nr_t;

count=0;
w = hann(nr_fft); % for later: the window
% for t=56*time_step:time_step:tstop-stime-time_step

sig=setstarttime(sig,0);
for t=tstart:time_step:tstop-stime-time_step
    count=count+1;
    s1=t;
    s2=t+stime;
    if s2<tstop
        s=getpart(sig,t,t+stime);    % von diesem Teil soll die FFT gemacht werden
    else % hier sollte er nicht hinkommen
        s=getpart(sig,t,tstop);
        s=expand(s,stime,0);    % fülle den Rest mit Nullen auf, damit das Signal auf jeden Fall lang genug ist
    end
    s=setstarttime(s,0);
        % damit die FFT nr_f Punkte hat, muss das Signal, womit sie gemacht wird, so lang sein:
%     s2=changesr(s,sr_neu);
    % ein HanningFenster drüberlegen:
    s=s*w;
    ps=powerspectrum(s,nr_f*2);
    % the resultig powesprect is one point too large, because of the zerovalue->strip it
    ps=strippowerspectrum(ps); % cut the leading zero
%     figure(1)
%     plot(s,'.-');
%     figure(2)
%     plot(ps,'.-');
    % normiere das Spektrum auf die maximale Amplitude des Signals
    ms=max(s);
    ps=ps*ms;
    f=setcolumn(f,count,ps);
end
