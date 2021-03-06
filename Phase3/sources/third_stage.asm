[ORG 0x10000]

[BITS 64]

Kernel:

bus_loop:
    device_loop:
        function_loop:
            call get_pci_device
            inc byte [function]
            cmp byte [function],8
        jne device_loop
        inc byte [device]
   mov byte [function],0x0
     cmp byte [device],32
     jne device_loop
    inc byte [bus]
    mov byte [device],0x0
    cmp byte [bus],255
    jne bus_loop

channel_loop:
    mov qword [ata_master_var],0x0
    master_slave_loop:
        mov rdi,[ata_channel_var]
        mov rsi,[ata_master_var]
        call ata_identify_disk
        inc qword [ata_master_var]
        cmp qword [ata_master_var],0x2
        jl master_slave_loop

    inc qword [ata_channel_var]
    inc qword [ata_channel_var]
    cmp qword [ata_channel_var],0x4
    jl channel_loop
    

call init_idt
call setup_idt
mov rsi,hello_world_str
call video_print

mov rsi,page_table_map_msg
call video_print

call page_table_map
;call _memory_check ;;test
mov rsi,success_msg
call video_print
;mov r8,14
;mov r9,0
;test_loop:
;mov rsi,testing
;call video_print
;inc r9
;cmp r9,r8
;jl test_loop
     ;mov rsi,testing
    ;call video_print
       
 ;   call video_print
        
  ;  call video_print
    
   ; call video_print   
    ;call video_print
    
    ;call video_print
        
    ;call video_print




;;TESTING
;mov rax,0x100000 ;; mapped
;mov rax,0xA0000 ;;not mapped
;mov rax, 0x9FC00 ;; mapped
;mov rax,0x101000 ;; mapped
;mov rax,0xFFFC0000 ;; not map
;mov rax,0x100000000 ;; not mapped
;mov rax,0x9FC01 ;; mapped
;mov rax,0x101000 ;;mapped
;mov rax,0x101000 ;; mapped
;mov rax,0xBFFE0000
;mov qword[rax],0x100
;xor rdi,rdi
;mov rdi, qword[rax]
;call bios_print_hex
;mov rsi,[rax]
;call video_print
;;END TESTING


kernel_halt: 
    hlt
    jmp kernel_halt


;*******************************************************************************************************************
      %include "sources/includes/third_stage/pushaq.asm"
      %include "sources/includes/third_stage/pic.asm"
      %include "sources/includes/third_stage/idt.asm"
      %include "sources/includes/third_stage/pci.asm"
      %include "sources/includes/third_stage/video.asm"
      %include "sources/includes/third_stage/pit.asm"
      %include "sources/includes/third_stage/ata.asm"
      %include "sources/includes/third_stage/page_table_map.asm"
      %include "sources/includes/third_stage/get_region_num.asm"

;*******************************************************************************************************************


colon db ':',0
comma db ',',0
newline db 13,0
end_of_string  db 13        ; The end of the string indicator
start_location   dq  0x0  ; A default start position (Line # 8)
    Test1 db '4',0
    Test2 db '3',0
    Test3 db '2',0
    Test4 db '1',0
    Default_msg db 'This is the Default',13,0,10
    mapping db 'Mapping...',13,0,10
    page_table_map_msg db 'Entering Function That Map The Memory',13,0,10
    hello_world_str db 'Hello all here',13, 0
    third_stage_ready db 'Third Stage of Bootloader is ready, Press any key to continue !',13,10,0
    success_msg db'Memory Mapped Successfully',13,0
    ata_channel_var dq 0
    ata_master_var dq 0

    bus db 0
    device db 0
    function db 0
    offset db 0
    hexa_digits       db "0123456789ABCDEF"         ; An array for displaying hexa decimal numbers
    ALIGN 4
testing db 'This message to test the video scroller',13,0,10
;times 8192-($-$$) db 0
;times 8798-($-$$) db 0 ;; limiation we changed it because we had an error that stated: TIMES -512
