function CDexport;
% CDexport - export calibration data shown on CDplot

% get data from calib plot
eh = findobj(gcbf, 'tag', 'Iam');
Export = get(eh, 'userdata');
Nfilt = length(Export.DF); % # filters = # calib curves
expFileName = strtok(Export.name, '.');
expFileName = [expFileName '_calib.txt'];

[FN FP] = uiputfile([exportdir '\' expFileName], ...
   'Specify filename for exported calibration data.');
if isequal(0,FN), return; end % user cancelled
FFN = fullfilename([FP FN], exportdir, 'txt');


% determine frequency range of calib data
Fmin = inf; Fmax = -inf;
for ifilt=1:Nfilt,
   df = Export.DF(ifilt);
   Nfreq = length(Export.maxAmp{ifilt}); 
   Fmax = max(Fmax, Nfreq*df);
   Fmax = max(Fmax, 1e3*(Nfreq-1)*df); % 1e3: kHz -> kHz
   % index of fisrt non-nan comp correspoinds to min freq coded
   Nmin = min(find(~isnan(Export.maxAmp{ifilt})));
   Fmin = min(Fmin, 1e3*df*Nmin); % 1e3: kHz -> kHz
end
% determine the new, uniform freq axis for all calibration data
DF = 1e3*max(Export.DF); % kHz->Hz
%Fmin, Fmax, DF
Ncomp = 1+round((Fmax-Fmin)/DF);
newfreq = linspace(Fmin, Fmax, Ncomp); % row vector
% now use interpolation to cast calib data to uniform freq scale
for ifilt=1:Nfilt,
   df = 1e3*Export.DF(ifilt); % in Hz
   Nfreq = length(Export.maxAmp{ifilt}); 
   oldfreq = df*(0:Nfreq-1);
   AmPhi(2*ifilt-1,:) = interp1(oldfreq, Export.maxAmp{ifilt}, newfreq);
   AmPhi(2*ifilt,:) = interp1(oldfreq, Export.Phase{ifilt}, newfreq);
end
% format string for prettyprinting depends on # filters
% columns are: freq (Hz)  [maxAmp (dB SPL) phi (cycle)]^Nfilt
%dsiz(newfreq, AmPhi)
Title = ['%% Calibration data: ' Export.name '.\n'];
header = ['%% Freq(Hz)  ' repmat('Amp(dB)  Phi(cycle) ' ,1,Nfilt) '\n'];
fstr = ['%8.1f   ' repmat('%5.1f    %7.3f    ' ,1,Nfilt) '\n'];

% write to text file
try, 
   fid = fopen(FFN, 'wt');
   fprintf(fid, Title);
   fprintf(fid, header);
   fprintf(fid, fstr, [newfreq; AmPhi]);
   fclose(fid);
catch, % make sure file is closed and give error message 
   mess = strvcat('Error while writing to file. MatLab message:', dealstring(lasterr));
   errordlg(mess, 'Error while writing to file.', 'modal');
   try, fclose(fid); end;
end



