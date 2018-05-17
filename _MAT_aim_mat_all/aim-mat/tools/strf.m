% support file for 'aim-mat'
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function retfld=strf(sig,spikes,start,stop,nrfre,maxfre)
% sig muss ein Signal sein
% st muss ein Spiketrain sein
% das Ergebnissignal hat die Länge bis-von
% das Ergebnis ist ein Feld mit der Länge stop-start und der Breite nrfre

if ~isobject(sig)
    disp('error: Signal must be an Object signal')
end

if nargin < 6
    maxfre=GetSR(sig)/2;
end
if nargin < 5
    nrfre=512;
end
if nargin < 4
    stop=0.01;  %standart: 10 ms nach 0
end
if nargin < 3
    start=-0.05;  %standart: 50 ms vor 0
end


% make one big spectrogram of the whole signal and then split the important
% parts:
bigspectrum=spectrogram(sig,nrfre,maxfre);

avera=mean(mean(getvalues(bigspectrum)));
nr_t=getnrt(bigspectrum);
nr_f=getnrf(bigspectrum);


duration= stop-start;  % so long is the signal that we want to analyse
nr_spikes=length(spikes);
orglen=GetLength(sig);


srf=getsr(bigspectrum);
res_nr_t=round(duration*srf);
all_vals=getvalues(bigspectrum);
fld=zeros(nr_f,res_nr_t);

for i=1:nr_spikes
    spiketime=spikes(i);
    t_start=spiketime+start;
%     t_stop=spiketime+stop;
    
    binstart=time2bin(srf,t_start);
    binstop=binstart+res_nr_t-1;
    
%     tempfeld=zeros(nr_f,res_nr_t);
    % fill the rest of the signal with the average value so that its not going
    % down im amplitude
    tempfeld=ones(nr_f,res_nr_t).*avera;
    
    if t_start >= orglen
        break; % no more relevant spikes in this spiketrain
    end
    
    if binstart>0 & binstop <= res_nr_t % der "Normalfall" (full signal is in window)
        tempfeld=all_vals(:,binstart:binstop);
    else % either start or stop are out of signal window
        if binstart<0  %wenn das Signal nicht so lang ist, müssen wir nullen vornedranhängen
            tempfeld(:,-binstart+1:end)=all_vals(:,1:binstop+1);
        end
        if binstop>res_nr_t %wenn das Signal länger sein sollte hängen wir Nullen hintenan
            nr_v=binstop-nr_t;
            tempfeld(:,1:(res_nr_t-nr_v))=all_vals(:,binstart:binstart+(res_nr_t-nr_v)-1);
        end
    end
%     if size(tempfeld,2)>res_nr_t
%         o=0;
%     end
    tempfeld=tempfeld(:,1:res_nr_t);
    fld=fld+tempfeld;
    
%     if mod(i,1)==0
%         figure(234)
%         testfld=field(res_nr_t,nr_f,srf);
%         testfld=setmaxfre(testfld,maxfre);
%         testfld=setoffset(testfld,start);
%         testfld=setvalues(testfld,fld);
%         plot(testfld,'log')
%         %         plot(fld)
%         drawnow
%     end
end

retfld=field(res_nr_t,nr_f,srf);
retfld=setmaxfre(retfld,maxfre);
retfld=setoffset(retfld,start);
retfld=setvalues(retfld,fld);



% figure(23423)
% plot(fld,'log');
% drawnow
