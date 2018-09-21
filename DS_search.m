function m=DS_search(dev,TI,r,tol)
% TI is a cell containing all TIs
% r is the ratio of nodes of TIs to be searched
sz = size(TI{1});
n = length(TI);
dev_sz = size(dev);
num_all_nodes = n*prod(sz-dev_sz+1); 
N= round(r*num_all_nodes);
search_path = randperm(num_all_nodes, N);
nn_ind=find(~isnan(dev));
m=zeros(1,n);
for i=1:N
    p=search_path(i);
    n_ti=floor((p-1)/prod(sz-dev_sz+1))+1;
    ind=mod((p-1),prod(sz-dev_sz+1))+1;
    [x,y]=ind2sub(sz-dev_sz+1,ind);
    temp=TI{n_ti}(x:x+dev_sz(1)-1,y:y+dev_sz(2)-1);
    d = sqrt(mean((temp(nn_ind)-dev(nn_ind)).^2));
    if d<=tol
        m(n_ti)=1;
        break
    end
end
    
    
