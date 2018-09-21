function C=TISelection_DS(Is,TI,params)

R=params.R; %maximum radius for dev,
try
    r=params.r; % ratio of all nodes of TIs to be searched
catch
    r=1;
end
tolerance = params.tolerance;
Cnt_dev=1;
for x = 1:size(Is,1)
    for y = 1:size(Is,1)
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
        
        m=DS_search(dev,TI,r,tolerance);
        S=sum(m);
        if S>0
            M(:,Cnt_dev)=m';
            Cnt_dev=Cnt_dev+1;
        end
    end
end
C=mean(M,2);



