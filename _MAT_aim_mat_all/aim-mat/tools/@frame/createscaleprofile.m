function ret_field=createscaleprofile(current_frame,options)
% creates a profile with an angle to the auditory image. The angle is
% ususally 45° and therefore the result is the collapsed Mellin image
% 

% do we want debugging graphic? (very nice!!)
grafix=0;

% the angle of the profile
if isfield(options,'angle')
    angle=options.angle;
else
    angle=45;   % in degrees
end

% the borders of the profiles are given by the minimum and the maximum
% harmonic relationship:
if isfield(options,'min_harmonic_relationship')
    min_harmonic_relationship=options.min_harmonic_relationship;
else
    min_harmonic_relationship=0.5; 
end
if isfield(options,'max_harmonic_relationship')
    max_harmonic_relationship=options.max_harmonic_relationship;
else
    max_harmonic_relationship=20; 
end
% how many points do we want to have on our profile?
if isfield(options,'nr_points')
    nr_points=options.nr_points;
else
    nr_points=200; 
end


% if we know about the periodicity, we can restrict ourself to the
% interesting region
if isfield(options,'periodicity')
    periodicity=options.periodicity;
else
    periodicity=0.035;   % in seconds
end

% translate to radian
angle=angle*2*pi/360;
tanangle=tan(angle);    % accelerate

cfs=getcf(current_frame);

vals=getvalues(current_frame);
nr_channels=getnrchannels(current_frame);




t_min=getminimumtime(current_frame);
t_max=getmaximumtime(current_frame);

if periodicity < t_max
    t_max=periodicity;
end

if t_min==0
	t_min=0.0001;
end

	
fre_min=1/t_max;
if t_min>0
	fre_max=1/t_min;
else
	fre_max=1000;
end

% das ist die niedrigste Frequenz, die auf der Basilarmembran zu finden ist
min_fre_current_frame=cfs(1);
% das bedeutet, dass wir über die harmonischen Grenzen rausfinden können,
% wie groß der Bereich ist, den wir gehen müssen:
% die untere harmonische Zahl gibt uns den oberen Wert:
smallest_interval_value=min_harmonic_relationship/min_fre_current_frame;
biggest_interval_value=max_harmonic_relationship/min_fre_current_frame;

% wieviel cent wollen wir tatsächlich untersuchen lassen:
% nr_cent=fre2cent(1/biggest_interval_value,1/smallest_interval_value); 	% so viele cent sind insgesamt im interval profile
% wir starten von links nach rechts und gehen in Schrittweite
% start_cent=fre2cent(fre_min,1/biggest_interval_value);

% Die Schrittweite berechnet sich aus den Extremen:
% delta_cent=nr_cent/(nr_points-1);

res_vals=zeros(1,nr_points);
for jj=1:nr_channels
	current_channel(jj)=getsinglechannel(current_frame,jj);
end
if grafix
	colors=['b','r','g','c','m','k','y'];
	figure(2);
	clf
	hold on
	str.is_log=1;
	str.time_reversed=1;
	str.minimum_time=t_min;
	str.maximum_time=t_max;
	plot(current_frame/1,str);
end

% start_harmonic_relations=linspace(min_harmonic_relationship,max_harmonic_relationship,nr_points);
start_harmonic_relations=distributelogarithmic(min_harmonic_relationship,max_harmonic_relationship,nr_points);


channel_step=1; % skip maybe some channels
nr_y_dots=floor(length(cfs)/channel_step);
% the result is a twoDfield with x=harmonic number and y=whateverthisis
% the number of field entries is given by the given number and the number
% of channels
result_field=zeros(nr_points,nr_y_dots);


for ii=1:nr_points
    current_start_cent=fre2cent(fre_min,cfs(1)/start_harmonic_relations(ii));
    y_count=1;
	for jj=1:channel_step:nr_channels
		% soviel cent ist dieser Kanal über dem ersten
		channel_diff_cent=fre2cent(cfs(1),cfs(jj));
		% soviel cent gehen wir nach rechts im Intervall
		cur_cent_x=channel_diff_cent/tanangle+current_start_cent;
		% das bedeutet diese Frequenz auf der Intervallachse:
		cur_fre=cent2fre(fre_min,cur_cent_x);
		cur_time=1/cur_fre;
		if cur_time> t_min && cur_time < t_max
			cur_val=gettimevalue(current_channel(jj),cur_time);
			if grafix
				col=colors(mod(ii,7)+1);
				plot3(time2bin(current_frame,cur_time),jj,cur_val/30,'.','color',col); 
			end
		else
			cur_val=0;
        end
        result_field(ii,y_count)=cur_val;
        y_count=y_count+1;
	end
end

% ret_field=frame(result_field');
% ret_field=setstarttime(ret_field,min_harmonic_relationship);
% newsr=nr_points/(max_harmonic_relationship-min_harmonic_relationship);
% ret_field=setsr(ret_field,newsr);
% ret_field=setxaxisname(ret_field,'harmonic ratio');
% return

% next step: calculate the autocorrelation function in each channel:

% grafix=1;
% res_field2=result_field;
% for ii=1:nr_points;
%     spalte=result_field(ii,:);
%     sig=signal(spalte,1);
%     acsig=autocorrelate(sig,1,getnrpoints(sig));
%     acsigvals=getvalues(acsig);
%     res_field2(ii,:)=acsigvals';
% 
% %     fftsig=powerspectrum(sig);
% %     nrs=linspace(1,getnrpoints(fftsig),getnrpoints(sig));
% %     ftsigvals=getvalues(fftsig);
% %     ftsigvals=ftsigvals(round(nrs));
% %     res_field2(ii,:)=-ftsigvals';
%     
%     
% %     if grafix
% %         figure(23423)
% %         clf
% %         hold on
% %         plot(acsig/max(acsig),'r');
% %         plot(ftsigvals/min(ftsigvals),'r');
% %         plot(sig/max(sig));
% %     end
%     p=0;
% end

% result_field=result_field';
% result_field=result_field(end:-1:1,:);
% result_field=result_field(:,end:-1:1);
ret_field=frame(result_field');

ret_field=setstarttime(ret_field,min_harmonic_relationship);
newsr=nr_points/(max_harmonic_relationship-min_harmonic_relationship);
ret_field=setsr(ret_field,newsr);
ret_field=setxaxisname(ret_field,'harmonic ratio');
% ret_field=setyaxisname(ret_field,'erb distance');

% supr=suprisemap(result_field);
% ret_field=supr';
return

% one dimensional profile
profile=signal(res_vals);
% profile=setunit_x(profile,'scaling-frequency dimension');


% scaliere die x-achse auf das wachsende harmonische Verhältnis:
% chr=current_harmonic_relation(end:-1:1);
% rprof=res_vals(end:-1:1);
% rprof=signal(rprof);
% nr_dots=length(chr);
% for i=1:length(chr)
%     n_y=f2f(i,1,nr_dots,min_harmonic_relationship,max_harmonic_relationship);
%     rx=interp1(chr,1:nr_dots,n_y);
%     nprof(i)=getbinvalue(rprof,rx);
% end
% 
% profile=signal(nprof);
profile=setstarttime(profile,min_harmonic_relationship);
newsr=getnrpoints(profile)/(max_harmonic_relationship-min_harmonic_relationship);
profile=setsr(profile,newsr);
profile=setunit_x(profile,'harmonic ratio');
