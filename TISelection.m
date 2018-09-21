function C=TISelection(Is,TI,cats,params)
N=params.N;% max number of triangles surrounding data-events
R=params.R; %maximum radius for dev,
Npad=params.Npad;
tolerance = params.tolerance;

% padding
Is=padarray(Is,Npad*ones(1,2),'symmetric');

% finding location of samples in Is
ind_samples=find(~isnan(Is));
[x,y]=ind2sub(size(Is),ind_samples);

%triangulation of all samples:
DT=delaunayTriangulation(x,y);
T=DT.ConnectivityList;% triangles
E = edges(DT);


% for continuous variable:
vals = Is(ind_samples);
if length(cats)<=1
    threshs=autoTriThresh2(x,y,vals,E);
    cats = [0:length(threshs)];
    threshs=[-inf,threshs,inf];
    valsC = zeros(size(vals));
    for i=1:length(threshs)-1
        valsC((vals>=threshs(i))&(vals<threshs(i+1)))=i-1;
    end
else
    valsC=vals;
end


% Removing triangles which have at least one vertex in the padded region
ind_in_pad=find(any(x(T)<=Npad,2)|any(y(T)<=Npad,2)|...
    any(x(T)>size(Is,1)-Npad,2)|any(y(T)>size(Is,2)-Npad,2));
T(ind_in_pad,:)=[];

Cnt_dev=1; % counter for data events

for L = cats(1:end-1)
    

    valsB=valsC==L;
    VTB=valsB(T);% Binary values at Triangles vertices
    
    % finding transitioning triangles
    indTt=find((VTB(:,1)&(~VTB(:,2)))|...
               (VTB(:,3)&(~VTB(:,1)))|...
               (VTB(:,2)&(~VTB(:,3))));
    Tt=T(indTt,:);% transitioning triangles
    
    % finding the dual graph for Tt
    AdjTt=dual_graph(Tt,valsB(Tt));
    
    
    % extract a data-event around each triangle and search TIs to find
    %    matches for it
    for i=1:size(Tt,1)
        
        % Computing centroid of central triangle
        xc= round(mean(x(Tt(i,:))));
        yc= round(mean(y(Tt(i,:))));
        
        % extracting data event
        devind=extract_dev2(i,R,N,Tt,AdjTt,x,y);
        %devind=extract_dev(i,N,Tt,AdjTt);
%         if length(devind)~=3+(N-1)
%             continue
%         end
        xdev=x(devind);
        ydev=y(devind);
        
        % Removing data which are too far from centriod from the dev
%         h=[xdev-xc,ydev-yc];% lag vectors
%         h_len=sqrt(sum(h.^2,2));
%         xdev = xdev(h_len<=R);
%         ydev = ydev(h_len<=R);
        
        % if no data in data-event, bypass the remining phases
        if isempty(xdev)
            continue
        end
        
        % extract the coordinates of avaiable data in dev with respect to
        %     its top left corner
        xmm = minmax (xdev');
        ymm = minmax (ydev');
        xdevr = xdev-xmm(1)+1;  % x for dev relative to top-left corner of dev
        ydevr = ydev-ymm(1)+1;  % y for dev relative to top-left corner of dev
        
        % constructing the data-event (containing nan for no-data)
        dev = nan(diff(xmm)+1, diff(ymm)+1);
        devindr = sub2ind(size(dev),xdevr,ydevr);
        devind = sub2ind(size(Is),xdev,ydev);
        dev (devindr) = Is(devind);
        
        
        
        
        
        
        
        
        
        
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
end
% try
    C=mean(M,2);
% catch
%     C=nan;
% end
