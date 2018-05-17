% tool
%
%   INPUT VALUES:
%
%   RETURN VALUE:
%
%
% This external file is included as part of the 'aim-mat' distribution package
% (c) 2011, University of Southampton
% Maintained by Stefan Bleeck (bleeck@gmail.com)
% download of current version is on the soundsoftware site: 
% http://code.soundsoftware.ac.uk/projects/aimmat
% documentation and everything is on http://www.acousticscale.org

function sig=gen_complex_damp(orgsig,carriers,halflifes,reprate,amplitudes)

% each combination possible
grafix=1;

for j=1:length(carriers)
    save_sigs(j)=generatedampsinus(orgsig,carriers(j),reprate(j),amplitudes(j),halflifes(j));
    
    if j==1
        gsig=save_sigs(j);
    else
        gsig=gsig+save_sigs(j);
    end
end

% savewave(tsig,'tsig');

sig=gsig;



if grafix
    plot_w=150;
    figure(1)
    clf
    subplot(3,1,[1,2])
    hold on
    nrc=length(carriers);
    
    % calculate where on the y-axis we are
    minf=100;
    maxf=5000;
    
    
    for i=1:nrc
        f=carriers(i);
        offx=f2f(f,minf,maxf,0,10,'loglin');
        plot(save_sigs(i)+offx);
    end
    set(gca,'xlim',[0 plot_w])
    set(gca,'ylim',[0 10])
    
    yt=[0.1 0.2 0.5 1 2 4]*1000;
    yt2=f2f(yt,minf,maxf,0,10,'loglin');
    set(gca,'ytick',yt2)
    set(gca,'yticklabel',yt)
    xlabel('')
    ylabel('frequency')
    title('part signals')
    subplot(3,1,3)
    plot(sig);
    set(gca,'xlim',[0 plot_w])
    title('total signal')

end