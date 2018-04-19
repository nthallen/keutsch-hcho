% function ChunkIndices = ChunkIndices(chunks)
%input is a vector containing output from chunker, which is [start indices,
%stop indices]
%output is single vector that contains all the indices within each chunk
%111811 JBK

function ChunkIndices = ChunkIndices(chunks)

ChunkIndices=[];
l=length(chunks);
for i=1:length(chunks);
    j = chunks(i,1):chunks(i,2);
    j=j';
    ChunkIndices=[ChunkIndices;j];
end
