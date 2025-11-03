
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global cygnals_enable_looping
.global cygnals_disable_looping

.section .fartext.sound_driver, "ax"


# ax - song state
cygnals_enable_looping:

    mov bx, ax
    or byte ptr [bx + MUSIC_STATE_FLAGS], CYG_STATE_FLAG_LOOP

    IA16_RET

# ax - song state
cygnals_disable_looping:

    mov bx, ax
    and byte ptr [bx + MUSIC_STATE_FLAGS], ~CYG_STATE_FLAG_LOOP

    IA16_RET

