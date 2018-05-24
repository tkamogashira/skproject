function coeffs = getcoeffs(this,hspecs,hspecsArbMag,fmethodArbMag)
%GETCOEFFS

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
F = hspecsArbMag.Frequencies*(Fs/2);

% Limit the mask to the frequency values inside the Nyquist interval. We will
% try to design a filter with a magnitude response that falls within the mask
% limits within the Nyquist interval. Use the interpolated masks to have better
% measurements that will tell if we have reached a design that meets the specs.
Fmask = hspecs.FmaskInterp(hspecs.FmaskInterp <= F(end));
Amask = hspecs.AmaskInterp(hspecs.FmaskInterp <= F(end),:);

% Minimum order design
endFlag = false;
endFlagFiner = false;
order = 0;

while endFlag == false
    order = order + 10;
    
    hspecsArbMag.FilterOrder = order;
    coeffs = actualdesign(fmethodArbMag,hspecsArbMag);
    
    % Correct the scale to have exact attenuation at reference frequency as
    % required by the standard.
    coeffs = correctGain(this,coeffs,Fs);
    
    % Measure the designed response and see if the magnitude fits within the
    % mask limits. If so, the design has been completed successfully.     
    Resp = freqz(coeffs{1},1,Fmask,Fs);
    Mag = 20*log10(abs(Resp));
    
    cond = ~any(Mag>Amask(:,1) | Mag<Amask(:,2));   
    if cond || isequal(order,3000)  
        endFlag = true;
        if isequal(order,3000) || any(isnan(Mag))
            warning(message('dsp:fdfmethod:abstractarbmagaudioweightfir:getcoeffs:NoConvergence'));            
        end
        % Refine the order by searching around the minimum order previously
        % achieved. Only if order is smaller than 1000.
        if order < 1000
            orderFiner = order-11;
            if orderFiner < 2
                %Equiripple designs can only be of order 3 or larger
                orderFiner = 2;
            end            
            while endFlagFiner == false
                orderFiner = orderFiner + 1;
                hspecsArbMag.FilterOrder = orderFiner;
                coeffs = actualdesign(fmethodArbMag,hspecsArbMag);
                
                coeffs = correctGain(this,coeffs,Fs);
                
                Resp = freqz(coeffs{1},1,Fmask,Fs);
                Mag = 20*log10(abs(Resp));
                                
                cond = ~any(Mag>Amask(:,1) | Mag<Amask(:,2));
                if cond || isequal(orderFiner,order)
                    endFlagFiner = true;
                end
            end
        end
    end
end

function  coeffsOut = correctGain(this,coeffs,Fs)
if (Fs/2) > this.RefFreq
    % Use freqz with a vector of frequencies as input. We are only interested in
    % the magnitude response at the second frequency value (the reference
    % frequency RefFreq) but need to pass two frequency values to be able to use
    % this format of freqz that computes the frequency response at a given set
    % of frequency values (this format does not accept a scalar frequency
    % point). 
    Resp = abs(freqz(coeffs{1},1,[0 this.RefFreq],Fs));
    g = this.RefAtten/Resp(2);
    coeffsOut{1} = coeffs{1}*g;
else    
    coeffsOut{1} = coeffs{1};
end
% [EOF]
