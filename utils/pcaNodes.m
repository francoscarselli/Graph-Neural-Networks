%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function pcaNodes(nN, nE)

    global dataSet
    [N cN MN sN]=pcaTrain(dataSet.trainSet.nodeLabels');
    dataSet.trainSet.nodeLabels=(N(:,1:nN))';
    
    [E cE ME sE]=pcaTrain(dataSet.trainSet.edgeLabels');
    dataSet.trainSet.edgeLabels=(E(:,1:nE))';
    
    if (isfield(dataSet, 'validationSet'))
	disp 'OOOOOOOOOOOOOOOOOO'
        doPCA('validationSet', 'nodeLabels', MN, sN, cN, nN);
        doPCA('validationSet', 'edgeLabels', ME, sE, cE, nE);
    end

    dataSet.config.nodeLabelsDim=nN;
    dataSet.config.edgeLabelsDim=nE;
end


function [nodes coefs M sA]=pcaTrain(A)
    M=mean(A);
    A0=A-repmat(M, size(A,1),1); 
    sA=std(A0);
    A0s = A0./repmat(sA, size(A,1),1);    
    [coefs nodes] = princomp(A0s);
end

function doPCA(set, type, M, sA, coefs, n)
    global dataSet
    A=dataSet.(set).(type)';
    A0=A-repmat(M, size(A,1),1); 
    A0s = A0./repmat(sA, size(A,1),1);    
    dataSet.(set).(type)=(A0s*coefs)';
    dataSet.(set).(type)=dataSet.(set).(type)(1:n,:);
end
