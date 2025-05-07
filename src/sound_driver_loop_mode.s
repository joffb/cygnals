
# Cygnals - Joe Kennedy 2025

#include <wonderful.h>
#include <ws.h>
#include "cygnals.h"

.code16
.arch i186
.intel_syntax noprefix

.global sound_enable_looping
.global sound_disable_looping

.section .text.sound_driver

# ax - song state
sound_enable_looping:

    mov bx, ax
    or byte ptr [bx + MUSIC_STATE_FLAGS], STATE_FLAG_LOOP

    WF_PLATFORM_RET

# ax - song state
sound_disable_looping:

    mov bx, ax
    and byte ptr [bx + MUSIC_STATE_FLAGS], ~STATE_FLAG_LOOP

    WF_PLATFORM_RET

