%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function setTestSet(graphNum,nNodes,connMatrix,maskVector,nodeLabels,edgeLabels,targets)

global dataSet dynamicSystem

dataSet.testSet=[];


dataSet.testSet.graphNum=graphNum;
dataSet.testSet.nNodes=nNodes;

dataSet.testSet.connMatrix=connMatrix;
sz=size(maskVector,1);
dataSet.testSet.maskMatrix=sparse(1:sz,1:sz,maskVector,sz,sz);
dataSet.testSet.nodeLabels=nodeLabels;
dataSet.testSet.edgeLabels=edgeLabels;
dataSet.testSet.targets=targets;

%% evaluating again useful data
E=speye(dynamicSystem.config.nStates);

[dataSet.testSet.neuralModel.childOfArc,dataSet.testSet.neuralModel.fatherOfArc]=find(dataSet.testSet.connMatrix);
dataSet.testSet.nArcs=size(dataSet.testSet.neuralModel.childOfArc,1);
dataSet.testSet.neuralModel.fatherToArcMatrix=logical(kron(sparse(1:dataSet.testSet.nArcs,...
    dataSet.testSet.neuralModel.fatherOfArc,ones(dataSet.testSet.nArcs,1),dataSet.testSet.nArcs,dataSet.testSet.nNodes),E));
dataSet.testSet.neuralModel.childToArcMatrix=logical(kron(sparse(1:dataSet.testSet.nArcs,...
    dataSet.testSet.neuralModel.childOfArc,ones(dataSet.testSet.nArcs,1),dataSet.testSet.nArcs,dataSet.testSet.nNodes),E));
[r,c]=find(ones(dynamicSystem.config.nStates,dynamicSystem.config.nStates*dataSet.testSet.nArcs,'uint8'));
dataSet.testSet.neuralModel.toBlockMatrixColumn=c;
dataSet.testSet.neuralModel.toBlockMatrixRow=r+floor((c-1)/dynamicSystem.config.nStates)*dynamicSystem.config.nStates;
dataSet.testSet.neuralModel.arcOfFatherMatrix=logical(sparse(1:dataSet.testSet.nArcs, dataSet.testSet.neuralModel.fatherOfArc,...
    ones(dataSet.testSet.nArcs,1),dataSet.testSet.nArcs,dataSet.testSet.nNodes));
