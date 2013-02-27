%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.





global dataSet dynamicSystem
dataSet.config.type='classification';



dataSet.config.nodeLabelsDim=1;
dataSet.config.edgeLabelsDim=1;
dataSet.config.rejectUpperThreshold=0;
dataSet.config.rejectLowerThreshold=0;


dataSet.trainSet.nNodes=20;
dataSet.trainSet.connMatrix=sparse(ones(20)-eye(20));
dataSet.trainSet.maskMatrix=sparse(eye(20));
dataSet.trainSet.nodeLabels=ones(1,20);
dataSet.trainSet.targets=-ones(1,20);
dataSet.trainSet.targets(1,1:5)=1;
dataSet.trainSet.edges=[];
k=1;
for i=1:5
    for j=1:5
        if j~=i
            dataSet.trainSet.edges(k).father=i;
            dataSet.trainSet.edges(k).child=j;
            dataSet.trainSet.edges(k).value=5;
            k=k+1;
        end
    end
end



dataSet.validationSet.nNodes=20;
dataSet.validationSet.connMatrix=sparse(ones(20)-eye(20));
dataSet.validationSet.maskMatrix=sparse(eye(20));
dataSet.validationSet.nodeLabels=ones(1,20);
dataSet.validationSet.targets=-ones(1,20);
dataSet.validationSet.targets(1,5:8)=1;
dataSet.validationSet.edges=[];
k=1;
for i=5:8
    for j=5:8
        if j~=i
            dataSet.validationSet.edges(k).father=i;
            dataSet.validationSet.edges(k).child=j;
            dataSet.validationSet.edges(k).value=5;
            k=k+1;
        end
    end
end




dataSet.testSet.nNodes=20;
dataSet.testSet.connMatrix=sparse(ones(20)-eye(20));
dataSet.testSet.maskMatrix=sparse(eye(20));
dataSet.testSet.nodeLabels=ones(1,20);
dataSet.testSet.targets=-ones(1,20);
dataSet.testSet.targets(1,3:8)=1;
dataSet.testSet.edges=[];
k=1;
for i=3:8
    for j=3:8
        if j~=i
            dataSet.testSet.edges(k).father=i;
            dataSet.testSet.edges(k).child=j;
            dataSet.testSet.edges(k).value=5;
            k=k+1;
        end
    end
end

dataSet.config.useLabelledEdges=1;

createEdgeLabelsMatrix;