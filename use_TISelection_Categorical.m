clear
load samplings/categorical/Is_samples_81.mat Is TI

params.N=inf;
params.R=12;
params.Npad=20;
params.tolerance = 0.001;


tic
for i=1:100
    for j=1:size(Is,3)
        Is0 = Is(:,:,j,i);
        M = TISelection(Is0,TI,[0,1,2],params);
        [~,m(i,j)] = max(M);
        waitbar(((i-1)*size(Is,3)+j)/(size(Is,3)*100))
    end
end
M=repmat([1:size(Is,3)],100,1);
Accuracy = mean(mean(M==m))
Average_time = toc/size(Is,3)/100



