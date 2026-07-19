.global _start
_start:
    li sp, 1024
    li gp, 6520       # Shifted up by 8 bytes to match the compiler!
    jal main

end_loop:
    j end_loop