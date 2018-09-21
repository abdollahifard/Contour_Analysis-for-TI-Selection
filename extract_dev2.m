function devind = extract_dev2(i,R,N,Tri,AdjTri,x,y)
%% Inputs:
% Tri: a triangulation containing triangles with at least two transitioning
%    links,
% AdjTri: adjacency matrix of dual graph of Tri,
% i: index of the specific triangle in Tri that we want to extract data 
%    event around it. 
% R : delimiter circle radius,
% N : maximum number of triangles considered in the neighborhood
%% Description: 
% we start dev with the indices of the central triangle vertices (Tri(i,:))
% on either side of the central triangle we find (N-1)/2 connected 
%    triangles, if avaiable, and attach the indices of their new vertices
%    to dev. 
%% Outputs:
% devind returns the indices of nodes in the data-event (not their positions
%     or values.
devind = Tri(i,:);
xnew = x(devind);% points inside data event
ynew = y(devind);
xc = mean (xnew);% centroid of base triangle
yc = mean (ynew);
d_new = sqrt((xnew-xc).^2+(ynew-yc).^2);

attached_tris = i;
i_ng = find(AdjTri(i,:));% indices of neighboring triangles
if isempty(i_ng)
    return
else
    while (~isempty(i_ng))&&(length(attached_tris)<N)
        
        j = i_ng(1);
        i_ng(1) = [];
        attached_tris(end+1) = j;
        xnew = x(Tri(j,:));
        ynew = y(Tri(j,:));
        d_new = sqrt((xnew-xc).^2+(ynew-yc).^2);
        if any(d_new>R)
            break
        else
            devind = cat(2,devind,Tri(j,:));
            k = find(AdjTri(j,:));
            new = setdiff(k,attached_tris);
            if ~isempty(new)
                i_ng(end+1) = new;
            end
        end
    end
end
devind=unique(devind)';
        
        
        
        
        
        
        