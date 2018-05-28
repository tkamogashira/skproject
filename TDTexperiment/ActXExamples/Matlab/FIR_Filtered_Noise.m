% This circuit and program generates FIR filtered noise

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\FIR_Filtered_Noise.rcx'); % Loads a circuit

if (RP.GetStatus)==7 % Checks to see that the circuit was loaded correctly
    
    % Cycles through the three FIR filters.
    for i = 1:3

        % Loads one set of filter coefficients to an FIR.
        RP.SendParTable('FIRfilts', i); 

        pause(2);

    end
    
    % Stop playing
    RP.Halt;
    
end
