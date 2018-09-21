function threshs=autoTriThresh2(x,y,Vals,E)

n_bins = 256;%ceil(sqrt(length(x)*5));%%%%% Empirical equation for no of bins
m1 = min(Vals);
m2 = max(Vals);
vbins = m1:(m2-m1)/(n_bins-1):m2;
d = sqrt(diff(x(E),1,2).^2+diff(y(E),1,2).^2);
dV = abs(diff(Vals(E),1,2));
dV(dV==0)=eps;
diffE = dV./d; % approximates derivative
Vavg = mean(Vals(E),2);
Vsig=dV/4;
h=repmat(diffE,1,length(vbins)).* ...
    exp(-(repmat(vbins,size(Vavg,1),1)-repmat(Vavg,1,length(vbins))).^2 ...
    ./(repmat(2*Vsig.^2,1,length(vbins))));
%plot(sum(h))

H=sum(h);
%plot(H)
m=max(H);
H1=circshift(H,[0,1]);
H2=circshift(H,[0,-1]);
LMB=(H>=H1)&(H>=H2)&(H>=0.1*m);
LMB([1,end])=false;
Hind=find(LMB);
DHind=diff(Hind);
th=25;
while any(DHind<th)
    ind=find(DHind<th,1,'first');
    if H(Hind(ind))>=H(Hind(ind+1))
        Hind(ind+1)=[];
    else
        Hind(ind)=[];
    end
    DHind=diff(Hind);
end
threshs=vbins(Hind);



