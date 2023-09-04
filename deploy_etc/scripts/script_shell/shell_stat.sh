function sta {
    stat -f "
    File: %N
    Size: %z bytes
    Type: %HT 

    Created: %SB
    Modified: %Sm
    Accessed: %Sa 

    Owner: %Su/%u
    Group: %Sg/%g
    Flags: %Of/%Sp/%SMp/%Sf
    " -t "%Y-%m-%d %H:%M:%S" $1
} 
