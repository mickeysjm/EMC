clc,clear
% row = pred, col = true
CM = csvread('confusion_matrix.csv',1,1);
K = size(CM,1);
CM_normal = zeros(K,K);

rsum = sum(CM,2);
rsum(find(rsum==0))=1;
rsum = 1./rsum;
for ii = 1:K
    CM_normal(ii,:) = CM(ii,:).*rsum(ii);
end
CM_diag = diag(CM);
CM_normal_diag = diag(CM_normal);
HeatMap(CM_normal)