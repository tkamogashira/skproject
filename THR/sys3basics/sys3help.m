function sys3help(ii);
%  sys3help - help on various TDT oddities.
%     sys3help(2) or sys3help 2   provides help on topic 2, etc.
%     Available topics are:
%
%      ---General----
%      (1)  Interface transfer rates (Optibit/GigaBit/USB).
%      (2)  Setting startup values for PA5 attenuators.
%      (3)  WordOut digital Output
%      (4)  Open RPvdsEX_manual.pdf (if TDT installed)
%      (5)  Open TDTsys3_manual.pdf (if TDT installed)
%      (6)  Open ActiveXhelp.chm    (if TDT installed)
%      (7)  Open RPXHelp.chm        (if TDT installed)
%      (8)  Specifying USB vs Gigabit interface.
%
%      ---RX6----
%      (11)  Hardware specs of the RX6.
%      (12)  Digital Input/Output settings
%      (13)  Sampling Rates of RX6
%      (14)  Front panel & IO channels
%      (15)  Wiring info for EARLY experiments
%
%      ---PP16 patch panel---
%      (21)  general description.
%      (22)  RX6 connections.
%      (23)  RP2 connections.
%
%      ---HB7 headphone buffer---
%      (31)  Attenuator (Voltage divider) to prevent overloading.
%      (32)  TDT Datasheet.
%
%      ---Online help---
%      (41)  [WWW] Current "Anomalies & Tech notes" (anomalies & bugs)
%      (42)  [WWW] Current TDT system 3 online help.
%
%     Note: for the topics marked [WWW] you need to be online.
%
%     See also tdthelp.

if nargin<1,
    help(mfilename);
    ii = input('Select topic > ');
    if isempty(ii), disp(' '); return; end
end

if ischar(ii), ii = str2double(ii); end

switch ii,
%      ---General----
%      (1)  Interface transfer rates (Optibit/GigaBit/USB).
%      (2)  Setting startup values for PA5 attenuators.
%      (3)  WordOut digital Output
%      (4)  Open RPvdsEX_manual.pdf (if TDT installed)
%      (5)  Open TDTsys3_manual.pdf (if TDT installed)
%      (6)  Open ActiveXhelp.chm    (if TDT installed)
%      (7)  Open RPXHelp.chm        (if TDT installed)
    case 1, local_lhelp Interface_Transfer_Rates.htm
    case 2, local_lhelp PA5_initialization.htm
    case 3, local_lhelp Addressing_Words.htm 
    case 4, winopen('C:\TDT\TDTHelp\RPvdsEx_Manual.pdf');
    case 5, winopen('C:\TDT\TDTHelp\TDTSys3_Manual.pdf');
    case 6, winopen('C:\TDT\TDTHelp\ActiveXHelp.chm');
    case 7, winopen('C:\TDT\TDTHelp\RPXHelp.chm');
    case 8, local_connection;
%      ---RX6----
%      (11)  Hardware specs of the RX6.
%      (12)  Digital Input/Output
%      (13)  RX6 Sampling Rates
    case 11, local_lhelp RX6_specs.htm
    case 12, local_lhelp RX6_Digial_Input_Output.htm
    case 13, local_lhelp RX6_Sampling_Rates.htm
    case 14, local_lhelp RX6_Front_Panel.htm
    case 15, local_wringhelp 
%      ---PP16 patch panel---
%      (21)  general description.
%      (22)  RX6 connections.
%      (23)  RP2 connections.
    case 21, local_lhelp PP16_Overview.htm
    case 22, local_lhelp PP16_to_RX6.htm
    case 23, local_lhelp PP16_to_RP2.htm
%      ---HB7 headphone buffer---
%      (31)  Attenuator (Voltage divider) to prevent overloading.
%      (32)  TDT Datasheet.
    case 31, local_type HB7.txt
    case 32, local_lhelp HB7.htm
%      ---Online help---
%      (41)  [WWW] Current "Anomalies & Tech notes" (anomalies & bugs)
%      (42)  [WWW] Current sys3 online help.
    case 41, web('-browser', 'http://www.tdt.com/T2Support/FlashHelp/System3TechNotes.htm');
    case 42, web('-browser', 'http://www.tdt.com/Sys3WebHelp/TDTHelp.htm');
%
    otherwise, error('You are beyond help.');
end




%----------------locals--------
function local_lhelp(FN);
% locally stored htm files 
helpdir = fullfile(versiondir, 'TDT\sys3basics\HelpTexts');
FFN = fullfile(helpdir, FN)
%web('-browser', FFN);
web(FFN);

function local_type(FN);
helpdir = fullfile(versiondir, 'TDT\sys3basics\HelpTexts');
type(fullfile(helpdir, FN));

function local_wringhelp 
disp(' ')
disp(' ')
disp('===Wiring for circuit RX6seqplay-trig-2ADC.rcx===');
disp('Event timing & its calibration')
disp('   BIT 0 = PP16[A1] spike trigger TTL (<- peak picker)');
disp('   BIT 3 = PP16[A4] calib pulse trigger TTL (<- out of easter egg)');
disp('   BIT 4 = PP16[A5] control relay connecting Analog_out-1 to');
disp('                    Digital_in Bit 1 (-> coil of easter egg)');
disp(' ')
disp('Analog recording & its calibration')
disp('   Bit 6 =  PP16[A7] control the relay that connects & disconnects');
disp('                     Analog_out-1 (Left) to Analog_in-1 (Left).');
disp('                     (->"bit 6" input of gray box)');
disp('   Analog-out-1 -> "DA" input of gray box)');
disp('   Analog-in-1 <- "AD" output of gray box)');
disp('=================================================');
disp(' ')



function local_connection;
disp(' ');
disp('Changing default hardware connection used by RPvdS.')
disp(' ');
disp('In REGEDIT navigate through by expanding the following folders:')
disp('   >My Computer');
disp('   ->HKEY_LOCAL_MACHINE');
disp('   -->SOFTWARE');
disp('   --->TDT');
disp('   ---->TDT Drivers');
disp(' '); 
disp('Select the TDT Drivers folder and on the right window you will see the following keys:');
disp('   (Default)');
disp('   INTERFACE');
disp('   VERSION');
disp('Next double-click on "INTERFACE", type "USB" and click "OK".');
disp(' Exit the registry, open zBUSmon and verify the title bar says');
disp(  '"zBus Monitor via USB Interface"');
disp('you should now be able to see your devices in the window.');
disp(' ');
disp(' ');
