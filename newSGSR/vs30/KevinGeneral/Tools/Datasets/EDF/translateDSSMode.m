function ModeStr = translateDSSMode(ModeNr)

%B. Van de Sande 04-08-2003, based on e-mail from Ravi Kochar received at 01-08-2003

switch ModeNr
case 1,  ModeStr = 'ton';     %Triangle modulated Frequency modulation (FM) // includes pure tones ...
case 2,  ModeStr = 'fms';     %Sine modulated Frequency Modulation (FM)  
case 3,  ModeStr = 'fml';     %Linear modulated Frequency modulation (FM)
case 4,  ModeStr = 'am';      %Amplitude Modulation (AM)
case 5,  ModeStr = 'gws';     %General Waveform (GW) - single cycle mode    
case 6,  ModeStr = 'gwr';     %General Waveform (GW) - repetitive mode // includes Shited GEWAB (SHFTGW) ...
case 7,  ModeStr = 'mks';     %Masked Stimulus - sine masker
case 8,  ModeStr = 'mkn';     %Masked Stimulus - noise masker
case 9,  ModeStr = 'zp';      %Zipwab
case 10, ModeStr = 'gam';     %General Waveform Amplitude Modulation - Tone modulates GW
case 11, ModeStr = 'gam';     %General Waveform Amplitude Modulation - GW modulates tone
case 12, ModeStr = 'csn';     %Cosine noise     
otherwise, ModeStr = '???'; end