% Model om effecten van faseverschuivingen op noise na te gaan
%
% function sumsin = sumsinPM(a1,freq1,freq2,freq3,phase1,phase2,phase3)
%
% PM 
% Sept. 06

function sumsin = sumsinPM(a1,freq1,freq2,freq3,phase1,phase2,phase3)

t = 0:0.1:10;

freqa = (freq1*(2*pi/1000)); 
freqb = (freq2*(2*pi/1000)); 
freqc = (freq3*(2*pi/1000));

close all

sumsinnophase = (a1*sin((freqa*t)))+(a1*sin((freqb*t)))+(a1*sin((freqc*t)));
sumsinphase = (a1*sin((freqa*t)+phase1))+(a1*sin((freqb*t)+phase2))+(a1*sin((freqc*t)+phase3));

figure(1)
subplot(3,1,1),plot(t,sumsinnophase),grid on
    title('sumsinnophase')
subplot(3,1,2),plot(t,sumsinphase),grid on
    title('sumsinphaseshift')
subplot(3,1,3),plot(t,sumsinnophase),grid on
    hold on    
plot(t,sumsinphase,'k.-')    
    title('Relatieve phaseshift: nophase blauw, phase zwart')
    xlabel('tijd (ms)')

figure(2)
subplot(3,2,1),plot(t,(sin(freqa*t))),grid on
    title('freq. 1st component')
subplot(3,2,3),plot(t,(sin(freqb*t))),grid on
    title('freq. 2nd component')    
subplot(3,2,2),plot(t,(sin((freqa*t)+phase1))),grid on
    title('phase effects 1st component')
subplot(3,2,4),plot(t,(sin((freqb*t)+phase2))),grid on
    title('phase effects 2nd component')
subplot(3,2,5),plot(t,(sin(freqc*t))),grid on
    title('freq. 3rd component')
subplot(3,2,6),plot(t,(sin((freqc*t)+phase3))),grid on
    title('phase effects 3rd component')
         
% Om ganse (samengestelde) golf te verschuiven (phase) moet phase 1 = freq/pi, phase 2 = freq2/pi, ...
% Op deze manier wordt van elke component (elke sinus in de samengestelde) een verschuiving van X periode bekomen.

% Alle componenten (sin1, sin2) zomaar (zonder frequentie-correctie) pi verschuiven 
% zorgt voor spiegelbeeld van samengestelde: zie telkens figuur 2.