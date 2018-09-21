function C=TISelection_partial(Is,TI,params)
% extracts m random data-events (m=r*numel(Is))

ind=randperm(numel(Is));
R=params.R; %maximum radius for dev,
try
    r=params.r;
catch
    r=0.01;
end
Npad=params.Npad;
tolerance = params.tolerance;

Cnt_dev=1;
for kk = 1:r*numel(Is)
    [x,y]=ind2sub(size(Is),ind(kk));
    dx1 = min(x-1,R);
    dx2 = min(size(Is,1)-x,R);
    dy1 = min(y-1,R);
    dy2 = min(size(Is,2)-y,R);
    temp = Is(x-dx1:x+dx2,y-dy1:y+dy2);
    [xtemp,ytemp] = find(~isnan(temp));
    d = sqrt((xtemp-(dx1+1)).^2+(ytemp-(dy1+1)).^2);
    xtemp(d>R)=[];
    ytemp(d>R)=[];
    ind_temp=sub2ind(size(temp),xtemp,ytemp);
    if isempty(xtemp)
        continue
    end
    xmm = minmax (xtemp');
    ymm = minmax (ytemp');
    xdev = xtemp-xmm(1)+1;  % x for dev relative to top-left corner of dev
    ydev = ytemp-ymm(1)+1;  % y for dev relative to top-left corner of dev
    
    % constructing the data-event (containing nan for no-data)
    dev = nan(diff(xmm)+1, diff(ymm)+1);
    devind = sub2ind(size(dev),xdev,ydev);
    dev (devind) = temp(ind_temp);
    
    
    mask=~isnan(dev);
    dev(~mask)=100;
    matchCnt=zeros(length(TI),1);
    for n_ti=1:length(TI)
        J=ssd(TI{n_ti},dev,mask);
        matchCnt(n_ti)=sum(sum(J<=tolerance));
    end
    S=sum(matchCnt);
    if S>0
        matchCnt=matchCnt/S;
        M(:,Cnt_dev)=matchCnt;
        Cnt_dev=Cnt_dev+1;
    end
end
C=mean(M,2);



