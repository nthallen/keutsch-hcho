% Fix scan index issue (FPGA switches to online label before the scan is
% actually complete)

function NewIndices  = scancorrect(i)
chunks = chunker(i);
NewChunks = [chunks(:,1) chunks(:,2)+25]; 
%There are 15 points at the end not labeled as scan points
NewIndices = ChunkIndices(NewChunks);

