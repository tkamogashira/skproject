slopecfplotDM(type)

% slopecfplotDM(type)
% makes a slopecfplot from the data in a list DM, saved in a file psML_SX
% if type = 'abs', then the absolute value of the slope is plotted against cf
% 
% TF 30/08/2005

load psML_SX;
cfs=[];
slopes=[];

for i=1:numel(DM)
    cfs(i) = DM(i).DSACXAC.thr.cf;
    slopes(i) = DM(i).slope;
end


if type=='abs', slopes=abs(slopes); end

scatter(cfs, slopes);
hold on;
xlabel('CF (Hz)');
ylabel('Slope (microsec/dB)');
line([0,3500], [0,0]);
hold off;