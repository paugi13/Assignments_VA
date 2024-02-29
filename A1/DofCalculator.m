function [DofN, DofD, ndirNodes] = DofCalculator(dirNodes,ndof)

ndirNodes = size(dirNodes,2);

DofD = zeros(ndirNodes*6, 1);
DofN = [1:ndof].';

j = 1;
for i = 1:ndirNodes
    DofD(j:j+5, 1) = dirNodes(i)*6-5:dirNodes(i)*6;
    j = j+6;
end

DofN(DofD) = [];
end