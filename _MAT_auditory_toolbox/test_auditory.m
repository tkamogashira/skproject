function test_auditory(test, pausetest)
% function test_auditory(test)
% Test each of the functions in the Auditory Toolbox.  The single argument
% is a string, containing the word 'all' or the name of one routine from the
% toolbox.  This routine defaults to running all tests.  There is a if pausetest, pause, end; after
% each plot, so be sure to hit the return key so the testing can proceed.
% 
if nargin < 1
	test = 'all';
end

if nargin < 2
   pausetest = 1;
end

if strcmp(test,'agc') | strcmp(test,'all')
	disp('agc test');
	set_window_size(200, 150);
	agc(ones(1,20), [.5;.5])
   plot(agc(ones(1,30), [.8; .5])); if pausetest, pause, end;
   plot(agc(ones(1,30),[.4;.5])); if pausetest, pause, end;;
	plot(agc(ones(1,30),[.4;.1])); if pausetest, pause, end;;
end

if strcmp(test,'CorrelogramArray') | strcmp(test,'all')
	disp('CorrelogramArray test');
	u=MakeVowel(4000,FMPoints(4000,120),16000,'u');
	soundsc(u,16000)
	coch=LyonPassiveEar(u,16000,1,4,.25);
	width = 256;
	cor=CorrelogramArray(coch,16000,16,width);
	[pixels frames] = size(cor);
	colormap(1-gray);
	for j=1:frames
		imagesc(reshape(cor(:,j),pixels/width,width));
		drawnow;
	end
end

if strcmp(test,'CorrelogramFrame') | strcmp(test,'all')
	disp('CorrelogramFrame test');
	for j=20:-1:1
		c(j,:) = max(0,sin((1:256)/256*(21-j)*3*2*pi));
	end
	picture=CorrelogramFrame(c,128,1,256);
	imagesc(picture)
	colormap(1-gray)
end

if strcmp(test,'CorrelogramMovie') | strcmp(test,'all')
	disp('CorrelogramMovie test');
	u=MakeVowel(4000,FMPoints(4000,120),16000,'u');
	soundsc(u,16000)
	coch=LyonPassiveEar(u,16000,1,4,.25);
	mov=CorrelogramMovie(coch,16000,16,256);
	movie(mov,-10,16)
end

if strcmp(test,'CorrelogramPitch') | strcmp(test,'all')
	disp('CorrelogramPitch test');
	u=MakeVowel(20000,FMPoints(20000,120),22254,'u');
	cor=CorrelogramArray(u,22254,50,256);
	p=CorrelogramPitch(cor,256,22254);
	plot(p)
	axis([0 45 110 130]); if pausetest, pause, end;;
	
	coch=LyonPassiveEar(u,22254,1,4,.5);
	cor=CorrelogramArray(coch,22254,50,256);
	p=CorrelogramPitch(cor,256,22254);
	plot(p)
	axis([0 45 110 130]); if pausetest, pause, end;;
	
	u=MakeVowel(20000,FMPoints(20000,120),22254,'u');
	n=randn([1 20000]).*(1:20000)/20000;
	un=u+n/4;
	coch=LyonPassiveEar(un,22254,1,4,.5);
	cor=CorrelogramArray(coch,22254,50,256);
	[pitch sal]=CorrelogramPitch(cor,256,22254,100,200);
	plot(pitch); if pausetest, pause, end;
	plot(sal); if pausetest, pause, end;
end

if strcmp(test,'DesignLyonFilters') | strcmp(test,'all')
	disp('DesignLyonFilters test');
	filts=DesignLyonFilters(16000);
	size(filts)
	filts(1:5,:)
	
	resp=soscascade([1 zeros(1,255)],filts);
	freqResp=20*log10(abs(fft(resp(1:5:88,:)')));
	freqScale=(0:255)/256*16000;
	semilogx(freqScale(1:128),freqResp(1:128,:))
	axis([100 10000 -60 20]); if pausetest, pause, end;;
end

if strcmp(test,'EpsilonFromTauFS') | strcmp(test,'all')
	disp('EpsilonFromTauFS test');
	eps=EpsilonFromTauFS(5,1)
	filter(1, [1 eps-1],[1 zeros(1,9)])
	sosfilters([1 zeros(1,9)],[1 0 0 eps-1 0])
end

if strcmp(test,'FMPoints') | strcmp(test,'all')
	disp('FMPoints test');
	u=MakeVowel(20000,FMPoints(20000,120), 22050,'u');
	soundsc(u/max(u), 22050)
end

if strcmp(test,'FreqResp') | strcmp(test,'all')
	disp('FreqResp test');
	filts=DesignLyonFilters(16000);
	f=10:10:7990;
	resp=FreqResp(filts(2, :), f, 16000);
	semilogx(f,resp);
	axis([100 10000 -50 20]);
end

if strcmp(test,'LyonPassiveEar') | strcmp(test,'all')
	disp('LyonPassiveEar test');
	is=LyonPassiveEar([1 zeros(1,255)],16000,1);
	imagesc(min(is, 0.0004)); if pausetest, pause, end;
	
	s=sin((0:2041)/20000*2*pi*1000);
	ys=LyonPassiveEar(s,20000,20);
	imagesc(ys/max(max(ys))); if pausetest, pause, end;;
	
	tap = wavread('tapestry.wav');
	coch=LyonPassiveEar(tap,16000,100);
	imagesc(coch/max(max(coch))); if pausetest, pause, end;;
end

if strcmp(test,'MakeERBFilters') | strcmp(test,'all')
	disp('MakeERBFilters test');
	fcoefs = MakeERBFilters(16000,10,100);
	y = ERBFilterBank([1 zeros(1,511)], fcoefs);
	resp = 20*log10(abs(fft(y')));
	freqScale = (0:511)/512*16000;
	semilogx(freqScale(1:255),resp(1:255,:));
	axis([100 16000 -60 0])
	xlabel('Frequency (Hz)'); 
	ylabel('Filter Response (dB)'); if pausetest, pause, end;;
	
	tap = wavread('tapestry.wav');
	fcoefs=MakeERBFilters(16000,40,100);
	coch=ERBFilterBank(tap, fcoefs);
	for j=1:size(coch,1)
		c=max(coch(j,:),0);
		c=filter([1],[1 -.99],c);
		coch(j,:)=c;
	end
	imagesc(coch);
end

if strcmp(test,'MakeVowel') | strcmp(test,'all')
	disp('MakeVowel test');
	vowels=[MakeVowel(10000,100,16000,'a') ...
		MakeVowel(10000,100,16000,'i') ... 
		MakeVowel(10000,100,16000,'u')];
	pause(3);soundsc(vowels,16000);
	
	vowels=[MakeVowel(1000,100,16000,'a')...
		MakeVowel(1000,100,16000,'i') ...
		MakeVowel(1000,100,16000,'u')];
	s=spectrogram(vowels,256,2,2);
	imagesc(s); if pausetest, pause, end;
end

if strcmp(test,'MeddisHairCell') | strcmp(test,'all')
	disp('MeddisHairCell test');
	tone=sin((0:4999)/20000*2*pi*1000);
	s=[zeros(1,5000) ...
	 tone*10^(40/20-1.35) zeros(1,5000) ...
	 tone*10^(45/20-1.35) zeros(1,5000) ...
	 tone*10^(50/20-1.35) zeros(1,5000) ...
	 tone*10^(55/20-1.35) zeros(1,5000) ...
	 tone*10^(60/20-1.35) zeros(1,5000) ...
	 tone*10^(65/20-1.35) zeros(1,5000) ...
	 tone*10^(70/20-1.35) zeros(1,5000) ...
	 tone*10^(75/20-1.35) zeros(1,5000) ...
	 tone*10^(80/20-1.35)];
	y=MeddisHairCell(s,20000);
	plot((1:90000)/20000,y(1:90000)); if pausetest, pause, end;
end

if strcmp(test,'mfcc') | strcmp(test,'all')
	disp('mfcc test');
	set_window_size(348, 188);
	tap = wavread('tapestry.wav');
	[ceps,freqresp,fb,fbrecon,freqrecon] = mfcc(tap,16000,100);
	imagesc(ceps); 
	colormap(1-gray); if pausetest, pause, end;
	imagesc(flipud(freqresp)); if pausetest, pause, end;
	imagesc(flipud(fb)); if pausetest, pause, end;
	imagesc(flipud(fbrecon)); if pausetest, pause, end;
	imagesc(flipud(freqrecon)); if pausetest, pause, end;
end

if strcmp(test,'proclpc') | strcmp(test,'all')
	disp('proclpc test');
	set_window_size(348, 188);
	[tap sr]= wavread('tapestry.wav');
	lpc_spec(tap,sr,13); if pausetest, pause, end;
	lpc_spec(tap,sr,26); if pausetest, pause, end;
end

if strcmp(test,'rasta') | strcmp(test,'all')
	disp('rasta test');
	tap = wavread('tapestry.wav');
	[ceps,freqresp,fb,fbrecon,freqrecon] = mfcc(tap,16000,100);
	rastaout = rasta(ceps,100);
	
	mfccDCTMatrix = 1/sqrt(40/2)*cos((0:(13-1))' * ...
				(2*(0:(40-1))+1) * pi/2/40);
	mfccDCTMatrix(1,:) = mfccDCTMatrix(1,:)*sqrt(2)/2;
	
	rastarecon = 0*fbrecon;
	for i=1:size(rastaout,2)
		rastarecon(:,i) = mfccDCTMatrix' * rastaout(:,i);
	end
	imagesc(flipud(rastarecon));
end

if strcmp(test,'SecondOrderFilter') | strcmp(test,'all')
	disp('SecondOrderFilter test');
	f=10:10:7990;
	sos=SecondOrderFilter(3000,5,16000)
	filt=[1 0 0 sos(2:3)]
	semilogx(f,FreqResp(filt,f,16000)); if pausetest, pause, end;
	
	filt=[sos 0 0]
	semilogx(f,FreqResp(filt,f,16000)); if pausetest, pause, end;
	
	sos=SecondOrderFilter(3000,2,16000)
	filt=[sos 0 0]
	semilogx(f,FreqResp(filt,f,16000)); if pausetest, pause, end;
end

if strcmp(test,'SeneffEar') | strcmp(test,'all')
	disp('SeneffEar test');
	s=[zeros(1,160) sin(2000*2*pi/16000*(1:1120))];
	y=SeneffEar(s,16000,15); if pausetest, pause, end;;
	
	tap = wavread('tapestry.wav');
	hc=SeneffEar(tap,16000);
	for j=1:40
		c=hc(j,:);
		c=filter([1],[1, -.99],c);
		h(j,:)=c(1:100:50381);
	end
	clf; imagesc(h); if pausetest, pause, end;;
end

if strcmp(test,'SetGain') | strcmp(test,'all')
	disp('SetGain test');
	filts=DesignLyonFilters(16000);
	filt=filts(42,:)
	f=10:10:7990;
	semilogx(f,FreqResp(filt,f,16000)); if pausetest, pause, end;;
	
	newFilt = SetGain(filt, 10, 1960, 16000);
	semilogx(f, FreqResp(newFilt, f, 16000)); if pausetest, pause, end;
end

if strcmp(test,'soscascade') | strcmp(test,'all')
	disp('soscascade test');
	soscascade([1 0 0 0 0],[1 0 0 -.9 0;1 1 0 0 0])
end

if strcmp(test,'sosfilters') | strcmp(test,'all')
	disp('sosfilters test');
	sosfilters([1 0 0 0 0 0],[1 0 0 -.9 0;1 0 0 -.8 0])
	sosfilters([1 0 0 0 0 0;2 0 0 0 0 0], ...
	            [1 0 0 -.9 0;1 0 0 -.8 0])
	sosfilters([1 0 0 0 0 0;2 0 0 0 0 0],[1 0 0 -.9 0])
end

if strcmp(test,'spectrogram') | strcmp(test,'all')
	disp('spectrogram test');
	tap = wavread('tapestry.wav');
	spec=spectrogram(tap,64,2,1);
	imagesc(spec); if pausetest, pause, end;;
end

if strcmp(test,'synlpc') | strcmp(test,'all')
	disp('synlpc test');
	[tap sr] = wavread('tapestry.wav');
	[aCoeff,resid,pitch,G,parcor,stream] = proclpc(tap,sr,13);
	syntap = synlpc(aCoeff, stream, sr, G);;
	pause(3);soundsc(syntap,16000);
	
	[aCoeff,resid,pitch,G,parcor,stream] = proclpc(tap,sr,13);
	stream=randn(size(stream));
	syntap = synlpc(aCoeff, stream, sr, G);;
	pause(3);soundsc(syntap,16000);
end

if strcmp(test,'WhiteVowel') | strcmp(test,'all')
	disp('WhiteVowel test');
	[tap sr] = wavread('tapestry.wav');
	whitetap = WhiteVowel(tap,16000,13,1000);
	pause(3);soundsc(whitetap, 16000);
end

function lpc_spec(tap,sr,L)
[aCoeff,resid,pitch,G,parcor,stream] = proclpc(tap,sr,L);
cft=0:(1/255):1;
spec = zeros(128, size(aCoeff,2));
for nframe=1:size(aCoeff,2)
	gain=20*log10(G(nframe)) * 0;
	for index=1:size(aCoeff,1)
		gain = gain + aCoeff(index,nframe)*exp(-i*2*pi*cft).^index;
	end
	gain = abs(1./gain);
	spec(:,nframe) = 20*log10(gain(1:128))';
end
imagesc(flipud(spec));



function set_window_size(width, height)
cursize = get(gcf, 'position');
cursize(3) = width+1;
cursize(4) = height+1;
set(gcf, 'position', cursize);



