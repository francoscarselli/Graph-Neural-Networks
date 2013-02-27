%Copyright (c) 2006, Franco Scarselli
%All rights reserved.
%
%Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
%
%Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
%Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
%
%THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



function [g,failed]=  generateUniformGraph(d,s)

g=sparse([2:d,d,1:(d-1),1],[1:(d-1),1,2:d,d],ones(2*d,1),d,d);

exch=0;
if(s> d/2 && (mod(s,2)==1 || mod(d,2)==0)),
    s=d-s;
    exch=1;
end

failed=0;
for i=1:d
    toAdd=s-sum(g(:,i));
    nav=find(sum(g)==s);
    av=setdiff(setdiff(find(g(:,i)==0),(1:i)'),nav);
    if (toAdd>length(av))
        failed=1;
        break
    end
    if(toAdd>0),
        av=av(randperm(length(av)));    %new
        rp=[];                          %new
        for p=2:s-1                     %new
            pp=find(sum(g(:,av))==p);   %new
            rp(end+1:end+length(pp))=av(pp);    %new
            if length(rp) == length(av) %new
                break                   %new
            end                         %new
        end                             %new
%         rp=randperm(length(av));      %old
%         g(av(rp(1:toAdd)),i)=1;       %old
%         g(i,av(rp(1:toAdd)))=1;       %old
         g(rp(1:toAdd),i)=1;
         g(i,rp(1:toAdd))=1; 
    end
end

if(exch) 
    g=(1-g)-eye(d);
end