function coeffs = actualdesign(this,hs)
%ACTUALDESIGN   

%   Copyright 2008-2011 The MathWorks, Inc.

specs = getdesignspecs(this,hs);
Gref = 0;

if ~isequal(hs.F0,1) && ~isequal(hs.F0,0)
    error(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:invalidSpecs1'));
end

%If design will not have ripple (S<1) then it makes no sense to specify
%orders greater than 2
if (specs.S <= 1) && (hs.FilterOrder > 2)
    error(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:invalidSpecs2'));
end

if (hs.FilterOrder < 2)
    error(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:invalidSpecs3'));
end
%%
%See if value of S does not yield an invalid imaginary Q
checkForLargeS(hs.G0,specs.S);

%Design a biquad shelving filter that will serve as the base for higher
%order designs.
%Second order designs and all-pass designs (G0=0) will be obtained directly
%from the biquadshelf function.
[B,A] = biquadshelf(hs.F0,hs.Fc,hs.G0,specs.S);

if (hs.FilterOrder > 2) && (hs.G0 ~=0)
    % Measure ripple and transition width of a second order shelf
    % design and match this transition width with a larger order
    % elliptical design by searching the right amount of ripple
    [H,w] = freqz(B,A,2^15);
    H = 20*log10(abs(H));
    
    %Measure passband ripple
    RipplePass = measripple(H,hs.G0,Gref);
    
    %Measure transition band-width
    Twidth = meastransitionbw(H,w,hs.F0,hs.Fc,hs.G0,Gref);
    
    % Higher order filter
    if hs.F0
        BW = 1-hs.Fc;
    else
        BW = hs.Fc;
    end
    GBW = hs.G0/2;
    
    done = 0;
    count = 0;    
    %first coarse search
    RippleVect = [linspace(RipplePass/100, RipplePass,10) RipplePass];
    while done == 0
        unrealizable = 1;
        for ii = 1:length(RippleVect)
            Ripple = RippleVect(ii);
            [F0_HO,G0_HO,Gref_HO,BW_HO,Gp,Gst] = getellipspecs(hs.F0,...
                hs.G0,Gref,BW,H,Ripple);
            
            [s,g] = designbwparameq(this,hs.FilterOrder,Gref_HO,G0_HO,Gp,...
                GBW,F0_HO*pi,BW_HO*pi,3,Gst);
            
            Hd = dfilt.df2sos(s,g);  
            [FreqResp,w] = freqz(Hd,2^15);
            FreqResp = 20*log10(abs(FreqResp));
            
            %Measure transition band-width
            TwidthHO = meastransitionbw(FreqResp,w,hs.F0,hs.Fc,...
                                            hs.G0,Gref);
            
            if TwidthHO <= Twidth
                unrealizable = 0;
                if abs(TwidthHO-Twidth)<0.00001
                    done = 1;
                else
                    if ii == 1
                        RippleVect = [linspace(RippleVect(ii)/100,...
                            RippleVect(ii),10),RippleVect(ii)];
                    else
                        RippleVect = [linspace(RippleVect(ii-1),...
                            RippleVect(ii),10),RippleVect(ii)];
                    end
                end
                break;
            end
        end
        if unrealizable == 1 || count == 50                  
            warning(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:UnableToObtainTransitionWidth'))            
            done = 1;
        end
        count = count + 1;
    end
else %if second order just put the cookbook's design in a SOS form
    s = [B A];
    g = 1;
end
coeffs = {s,g};

end
%% --------------------------------------------------------------------
function checkForLargeS(g0,S)
    Ag = 10^(g0/40);
    Q = inv( sqrt((Ag+(1/Ag))*((1/S)-1)+2) );
    if ~isreal(Q)
        error(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:VeryLargeS'))
    end
end
%% --------------------------------------------------------------------
function r = measripple(H,G0,Gref)
%MEASRIPPLE measure ripple    
    idxMax = find(H == max(H));
    idxMax = idxMax(1);
    if G0>Gref 
        r = H(idxMax)-G0;        
    else  
        r = H(idxMax)-Gref;
    end  
end

%% --------------------------------------------------------------------
function [B,A] = biquadshelf(F0,Fc,G0,S)
%BIQUADSHELF   
% Create a second order shelving filter according to the Audio EQ
% cookbook found in http://www.musicdsp.org/files/Audio-EQ-Cookbook.txt
w0 = pi*Fc;
Ag=10^(G0/40);
alpha = (sin(w0)/2)*sqrt( (Ag+(1/Ag))*((1/S)-1)+2);

if F0 %high pass shelf
    b0 = Ag*( (Ag+1) + (Ag-1)*cos(w0) + 2*sqrt(Ag)*alpha );
    b1 = -2*Ag*( (Ag-1) + (Ag+1)*cos(w0) );
    b2 = Ag*( (Ag+1) + (Ag-1)*cos(w0) - 2*sqrt(Ag)*alpha );
    a0 = (Ag+1) - (Ag-1)*cos(w0) + 2*sqrt(Ag)*alpha;
    a1 = 2*( (Ag-1) - (Ag+1)*cos(w0));
    a2 = (Ag+1) - (Ag-1)*cos(w0) - 2*sqrt(Ag)*alpha;    
else %low pass shelf    
    b0 = Ag*( (Ag+1) - (Ag-1)*cos(w0) + 2*sqrt(Ag)*alpha );
    b1 = 2*Ag*( (Ag-1) - (Ag+1)*cos(w0) );
    b2 = Ag*( (Ag+1) - (Ag-1)*cos(w0) - 2*sqrt(Ag)*alpha );
    a0 = (Ag+1) + (Ag-1)*cos(w0) + 2*sqrt(Ag)*alpha;
    a1 = -2*( (Ag-1) + (Ag+1)*cos(w0));
    a2 = (Ag+1) + (Ag-1)*cos(w0) - 2*sqrt(Ag)*alpha;
end
B = [b0, b1, b2]/a0;
A = [a0, a1, a2]/a0;
end

%% --------------------------------------------------------------------
function TB = meastransitionbw(H,w,F0,Fc,G0,Gref)
%MEASTRANSITIONBW measure transition bandwidth 
if any(isnan(H))
    error(message('dsp:fdfmethod:abstractellipparameqaudioshelf:actualdesign:UnableToObtainFilter'))
end
    idxL = w<(Fc*pi);
    idxH = ~idxL;
    HL = flipud(H(idxL));
    wL = flipud(w(idxL));
    HH = H(idxH);
    wH = w(idxH);
    
    
    if (F0 && G0>Gref) %highpass boost
        idx1 = find(HL<=Gref);
        idx2 = find(HH >= G0);
    elseif (F0 && G0<Gref) %highpass cut        
        idx1 = find(HL>=Gref);
        idx2 = find(HH<=G0);
    elseif (~F0 && G0>Gref) %lowpass boost
        idx1 = find(HL>=G0);
        idx2 = find(HH<=Gref);        
    else %(~F0 && G0<Gref) lowpass cut
        idx1 = find(HL<=G0);
        idx2 = find(HH >= Gref);        
    end
    
    w1 = wL(idx1(1));    
    w2 = wH(idx2(1));
    TB = (w2-w1)/pi;
    
end
%% --------------------------------------------------------------------
function [F0, G0, Gref, BW, Gp, Gst] = getellipspecs(f0,g0,gref,bw,H,Ripple)
   %GETELLIPSPECS
  
   if (f0 && g0>gref) || (~f0 && g0<gref) %highpass boost or lowpass cut
       BW = bw;
       F0 = f0;
       G0 = H(end)+Ripple;
       Gref = H(1)-Ripple;
       %a lowpass cut has same form as a highpass boost so we design a
       %highpass boost with a  bandwidth of 1-bw
       if (~f0 && g0<gref) 
           BW = 1-bw;
           F0 = 1;
       end
       Gp = H(end); 
       Gst = H(1);  
   else %(f0 &&  g0<gref) || (~f0 && g0>gref) highpass cut or lowpass boost
       BW = bw;
       F0 = f0;
       G0 = H(1)+Ripple;
       Gref = H(end)-Ripple;
       %a highpass cut has same form as a lowpass boost so we design a
       %lowpass boost with a  bandwidth of 1-bw       
       if (f0 &&  g0<gref)
           BW = 1-bw;
           F0 = 0;
       end
       Gp = H(1); 
       Gst = H(end); 
   end
end
% [EOF]
