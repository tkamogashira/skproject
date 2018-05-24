function coeffs = getcoeffs(~,hspecs,hspecsArbMag,fmethodArbMag)
%GETCOEFFS

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
F = hspecsArbMag.Frequencies*(Fs/2);

% Limit the mask to the frequency values inside the Nyquist interval. We will
% try to design a filter with a magnitude response that falls within the mask
% limits within the Nyquist interval.
Fmask = hspecs.Fmask(hspecs.Fmask <= F(end));
Amask = hspecs.Amask(hspecs.Fmask <= F(end),:);

% Gain at 6300 Hz should be exactly 12.2 according to the ITU-R 468-4 standard
a6300 = 10^(12.2/20);

% Minimum order design
endFlag = false;
order = 1;

while endFlag == false
    order = order + 1;
    
    hspecsArbMag.FilterOrder = order;
    coeffs = actualdesign(fmethodArbMag,hspecsArbMag);
       
    Htemp = dfilt.df2sos(coeffs{1},coeffs{2});
    
    % Correct the gain so that we have 0 dB attenuation at 6300 Hz
    if (Fs/2) > 6300  
        % Use freqz with a vector of frequencies as input. We are only
        % interested in the magnitude response at the second frequency value
        % (the reference frequency) but need to pass two frequency
        % values to be able to use this format of freqz that computes the
        % frequency response at a given set of frequency values (this format
        % does not accept a scalar frequency point).        
        Resp = abs(freqz(Htemp,[0 6300],Fs));        
        g = a6300/Resp(2);
        Htemp.ScaleValues(1) = Htemp.ScaleValues(1)*g;
    end
    
    % Measure the designed response and see if the magnitude fits within the
    % mask limits. If so, the design has been completed successfully. 
    Resp = freqz(Htemp,Fmask,Fs);
    Mag = 20*log10(abs(Resp));
    
    cond = ~any(Mag>Amask(:,1) | Mag<Amask(:,2));   
    if cond || isequal(order,15)  
        endFlag = true;
        if isequal(order,15) || any(isnan(Mag))
            warning(message('dsp:fdfmethod:lpnormaudioweightitur4684:getcoeffs:NoConvergence'));
        end
        coeffs = {Htemp.sosMatrix, Htemp.ScaleValues};
    end
end

% [EOF]
