function sf=setupFile(fn);
% SETUPFILE - returns full name of SGSRsetup file in  setup directory as char string
sf = [setupDir filesep fn '.SGSRsetup'];