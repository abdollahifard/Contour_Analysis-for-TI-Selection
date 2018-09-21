function Adj = dual_graph(Tri,VTri)
% Tri is a set of triangles and Vtri is the BINARY matrix giving the values
%    of the nodes at the vertices of the triangles (the same size as Tri)
% The function returns the dual matrix, where each face of the given
%    triangulaiton is considered as a node of new graph and two nodes are
%    connected iff the corresponding triangles share a common link and the
%    link is transitioning (having different values at its endpoints). 
% Adj is the adjacency matrix of the dual graph. 
% n = size(Tri,1);% num of nodes of dual graph
% Adj = zeros(n);
% for i = 1:n
%     tri = Tri(i,:);
%     vtri = VTri(i,:);
%     for j = i+1:n
%         [~,itri,~]=intersect(tri,Tri(j,:));
%         if length(itri)==2
%             if vtri(itri(1))~=vtri(itri(2))
%                 Adj(i,j)=1;
%             end
%         end
%     end
% end
% Adj = Adj + Adj';







n = size(Tri,1);% num of nodes of dual graph
Adj = zeros(n);
if n==1
    return
end
for i = 1:n
    tri = Tri(i,:);
    vtri = VTri(i,:);
    B1 = sum(tri(1)==Tri,2);B1(i)=0;
    B2 = sum(tri(2)==Tri,2);B2(i)=0;
    B3 = sum(tri(3)==Tri,2);B3(i)=0;
    if vtri(1)==vtri(2)
        ind=find((B1&B3)|(B2&B3));
        if ~isempty(ind)
            Adj(i,ind)=1;
        end
    elseif vtri(2)==vtri(3)
        ind=find((B1&B2)|(B1&B3));
        if ~isempty(ind)
            Adj(i,ind)=1;
        end
    else
        ind=find((B1&B2)|(B2&B3));
        if ~isempty(ind)
            Adj(i,ind)=1;
        end
    end
end

