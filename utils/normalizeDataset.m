%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function normalizeDataset
% This function normalize the dataSet, as values bigger than one are bad for learning
% The idea is to divide by 10 and cut to 1 values over 1 (i.e. values over 10 in the original dataset)
% Division by 10 is an idea to have less values cut to 1.


global dataSet
if isfield(dataSet,'validationSet')
	sets={'trainSet','validationSet','testSet'};
else
	sets={'trainSet','testSet'};
end

for s=1:size(sets,2)
	comp=find(max(dataSet.(sets{s}).nodeLabels,[],2)>1); %% problematic components
	dataSet.(sets{s}).nodeLabels(comp,:)=dataSet.(sets{s}).nodeLabels(comp,:)/10;
	[bigr bigc]=find(dataSet.(sets{s}).nodeLabels(comp,:)>1);
	bigr=comp(bigr);
	for i=1:size(bigr,1)
		dataSet.(sets{s}).nodeLabels(bigr(i),bigc(i))=1;
	end
	comp=find(max(dataSet.(sets{s}).edgeLabels,[],2)>1); %% problematic components
	dataSet.(sets{s}).edgeLabels(comp,:)=dataSet.(sets{s}).edgeLabels(comp,:)/10;
	[bigr bigc]=find(dataSet.(sets{s}).edgeLabels(comp,:)>1);
	bigr=comp(bigr);
	for i=1:size(bigr,1)
		dataSet.(sets{s}).edgeLabels(bigr(i),bigc(i))=1;
	end
end

