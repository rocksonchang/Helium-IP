function h=IP_ReadNotes(h)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Function to read notes
fname=[h.folderName '\Notes.txt'];
if (exist(fname)==2)
    fid = fopen(fname, 'r');
    tline = fgetl(fid);    
    temp=[];
    while ischar(tline)
        temp = [temp; tline;];
        tline = fgetl(fid);
    end    
    set(h.editNotes,'string',temp);
    fclose(fid);
else
    temp='Enter notes here';
    set(h.editNotes,'string',temp);
end;