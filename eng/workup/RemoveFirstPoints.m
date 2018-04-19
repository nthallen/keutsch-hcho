%function FirstPointsRemoved = RemoveFirstPoints(i,n)
%input is the online indices and the number of points at the start of each
%cycles you wish to remove, assessed after viewing the raw data for errors

%output is the online indices without erroneous points
%111811 JBK
%05APR2018 JDS

function [NewIndices,RemovedIndices]  = RemoveFirstPoints(i, n)
chunks = chunker(i);
OriginalStart = chunks(:,1);
NewStart = OriginalStart+n;

NewChunks = [NewStart chunks(:,2)];
NewIndices = ChunkIndices(NewChunks);

RemovedChunks = [OriginalStart NewStart];
RemovedIndices = ChunkIndices(RemovedChunks);

