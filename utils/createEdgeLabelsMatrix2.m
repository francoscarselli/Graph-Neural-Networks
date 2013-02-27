%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function data=createEdgeLabelsMatrix2(data)

index=find(data.trainSet.connMatrix);
sx=size(index,1);

if ~isfield(data.trainSet,'edges')
    error('I can''t find edge labels in the train set');
end
data.trainSet.edgeLabels=ones(data.config.edgeLabelsDim,sx);  
for i=1:size(data.trainSet.edges,2)
    ind=find(index==(data.trainSet.edges(i).father-1)*data.trainSet.nNodes+data.trainSet.edges(i).child);
    if isempty(ind)
        error('I''ve found a label for an arc in the train set that doesn''t seem to exist');
    end
    data.trainSet.edgeLabels(:,ind)=data.trainSet.edges(i).value;
end


index=find(data.validationSet.connMatrix);
sx=size(index,1);

if ~isfield(data.validationSet,'edges')
    error('I can''t find edge labels in the validation set');
end
data.validationSet.edgeLabels=ones(data.config.edgeLabelsDim,sx);  
for i=1:size(data.validationSet.edges,2)
    ind=find(index==(data.validationSet.edges(i).father-1)*data.validationSet.nNodes+data.validationSet.edges(i).child);
    if isempty(ind)
        error('I''ve found a label for an arc in the validation set that doesn''t seem to exist');
    end
    data.validationSet.edgeLabels(:,ind)=data.validationSet.edges(i).value;
end

index=find(data.testSet.connMatrix);
sx=size(index,1);

if ~isfield(data.testSet,'edges')
    error('I can''t find edge labels in the test set');
end
data.testSet.edgeLabels=ones(data.config.edgeLabelsDim,sx);  
for i=1:size(data.testSet.edges,2)
    ind=find(index==(data.testSet.edges(i).father-1)*data.testSet.nNodes+data.testSet.edges(i).child);
    if isempty(ind)
        error('I''ve found a label for an arc in the test set that doesn''t seem to exist');
    end
    data.testSet.edgeLabels(:,ind)=data.testSet.edges(i).value;
end

data.trainSet=rmfield(data.trainSet,'edges');
data.validationSet=rmfield(data.validationSet,'edges');
data.testSet=rmfield(data.testSet,'edges');