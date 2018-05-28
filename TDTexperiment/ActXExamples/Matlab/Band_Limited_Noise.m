% This circuit and program generates band-limited noise using a ParaCoef
% The user can set the center frequency, bandwidth, and gain of the filter
% and the amplitude of the noise. 
% It checks for clipping (> +/-10 volts).

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\Band_Limited_Noise.rcx'); % Loads a circuit

if (RP.GetStatus==7) % checks to see that the circuit was loaded correctly
    
    test = 0;
    while (test == 0)
        % User gives information about the center frequency, Bandwidth, gain of filter, and amplitude of noise
        Freq=input('Enter the center frequency for the filter: ');
    	Gain=input('Enter the dB gain for the filter: ');
        Bandwidth=input('Enter the bandwidth for the filter: ');
    	Amp=input('Enter the intensity for the noise: ');
        test = (isnumeric([Freq Gain Bandwidth Amp]));
        if test == 0
            disp(' ');
            disp('Error: Inputs must be numbers.  Try again');
        end
    end

    % Sets the initial settings for the filter coefficients and the noise
    RP.SetTagVal('Gain',Gain); % Gain of band limited filter
    RP.SetTagVal('Freq',Freq); % CenterFrequency
    RP.SetTagVal('BW',Bandwidth); % Bandwidth of filter
    RP.SetTagVal('Amp',Amp); % Amplitude of the Gaussian Noise
    RP.SetTagVal('Enable',1); % Loads Coefficients to Biquad Filter
    RP.SetTagVal('Enable',0); % Stops Coefficient generator from sending signal (saves on cycle usage)
    
	quit=0;
	while quit==0
   	    Clip=RP.GetTagVal('Clip'); % Checks to see if signal is clipped (top light on panel is on while clipping occurs)
   	    if Clip==1
      	    disp('Gain of filter or noise intensity is too high');
        	a=input('Type 1 to change filter Gain, 2 for Amp, 3 for Both:' ); % Queries user for what they want changed
      	if a==1
         	Gain=input('Enter Gain value:' );
         	RP.SetTagVal('Gain',Gain); % Alters coefficient Gain
      	elseif a==2
         	Amp=input('Enter Amplitude value:' );
         	RP.SetTagVal('Amp',Amp); % Alters noise amplitude
        elseif a==3
         	Amp=input('Enter Amplitude value:' ); % Alters both
         	RP.SetTagVal('Amp',Amp);
				Gain=input('Enter Gain value:' );
         	RP.SetTagVal('Gain',Gain);
        else
            disp('Error: Invalid response');
      	end
      	RP.SetTagVal('Enable',1); % Starts the coefficient generator
      	RP.SetTagVal('Enable',0); % Stops ParCoef generation
   	end
   	quit=input('Continue testing? 0 for yes 1 for No: ');
   end
end

RP.Halt;