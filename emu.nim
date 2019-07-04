#[
Copyright (c) Rupansh Sekar. All rights reserved.
Licensed under the MIT license. See LICENSE file in the project root for details.
]#

import streams
import c_alikes

type
  conditionCodes* {.bycopy.} = object
    z* {.bitsize: 1.}: uint8
    s* {.bitsize: 1.}: uint8
    p* {.bitsize: 1.}: uint8
    cy* {.bitsize: 1.}: uint8
    ac* {.bitsize: 1.}: uint8 # unused for space invaders
    pad* {.bitsize: 3.}: uint8

  state* {.bycopy.} = object
    a*: uint8
    b*: uint8
    c*: uint8
    d*: uint8
    e*: uint8
    h*: uint8
    l*: uint8
    sp*: uint16
    pc*: uint16
    mem*: ptr uint8
    cc*: conditionCodes
    intEnable*: uint8


proc disassemble8080(codebuffer: ptr uint8; pc: int): int =
  var code: ptr uint8 = addr((codebuffer)[pc])
  var opbytes: int = 1
  echo("%04x ", pc)
  case code[]
  of 0x00:
    echo("NOP")
  of 0x01:
    echo("LXI    B,#$%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x02:
    echo("STAX   B")
  of 0x03:
    echo("INX    B")
  of 0x04:
    echo("INR    B")
  of 0x05:
    echo("DCR    B")
  of 0x06:
    echo("MVI    B,#$%02x", (code)[1])
    opbytes = 2
  of 0x07:
    echo("RLC")
  of 0x08:
    echo("NOP")
  of 0x09:
    echo("DAD    B")
  of 0x0A:
    echo("LDAX   B")
  of 0x0B:
    echo("DCX    B")
  of 0x0C:
    echo("INR    C")
  of 0x0D:
    echo("DCR    C")
  of 0x0E:
    echo("MVI    C,#$%02x", (code)[1])
    opbytes = 2
  of 0x0F:
    echo("RRC")
  of 0x10:
    echo("NOP")
  of 0x11:
    echo("LXI    D,#$%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x12:
    echo("STAX   D")
  of 0x13:
    echo("INX    D")
  of 0x14:
    echo("INR    D")
  of 0x15:
    echo("DCR    D")
  of 0x16:
    echo("MVI    D,#$%02x", (code)[1])
    opbytes = 2
  of 0x17:
    echo("RAL")
  of 0x18:
    echo("NOP")
  of 0x19:
    echo("DAD    D")
  of 0x1A:
    echo("LDAX   D")
  of 0x1B:
    echo("DCX    D")
  of 0x1C:
    echo("INR    E")
  of 0x1D:
    echo("DCR    E")
  of 0x1E:
    echo("MVI    E,#$%02x", (code)[1])
    opbytes = 2
  of 0x1F:
    echo("RAR")
  of 0x20:
    echo("NOP")
  of 0x21:
    echo("LXI    H,#$%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x22:
    echo("SHLD   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x23:
    echo("INX    H")
  of 0x24:
    echo("INR    H")
  of 0x25:
    echo("DCR    H")
  of 0x26:
    echo("MVI    H,#$%02x", (code)[1])
    opbytes = 2
  of 0x27:
    echo("DAA")
  of 0x28:
    echo("NOP")
  of 0x29:
    echo("DAD    H")
  of 0x2A:
    echo("LHLD   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x2B:
    echo("DCX    H")
  of 0x2C:
    echo("INR    L")
  of 0x2D:
    echo("DCR    L")
  of 0x2E:
    echo("MVI    L,#$%02x", (code)[1])
    opbytes = 2
  of 0x2F:
    echo("CMA")
  of 0x30:
    echo("NOP")
  of 0x31:
    echo("LXI    SP,#$%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x32:
    echo("STA    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x33:
    echo("INX    SP")
  of 0x34:
    echo("INR    M")
  of 0x35:
    echo("DCR    M")
  of 0x36:
    echo("MVI    M,#$%02x", (code)[1])
    opbytes = 2
  of 0x37:
    echo("STC")
  of 0x38:
    echo("NOP")
  of 0x39:
    echo("DAD    SP")
  of 0x3A:
    echo("LDA    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0x3B:
    echo("DCX    SP")
  of 0x3C:
    echo("INR    A")
  of 0x3D:
    echo("DCR    A")
  of 0x3E:
    echo("MVI    A,#$%02x", (code)[1])
    opbytes = 2
  of 0x3F:
    echo("CMC")
  of 0x40:
    echo("MOV    B,B")
  of 0x41:
    echo("MOV    B,C")
  of 0x42:
    echo("MOV    B,D")
  of 0x43:
    echo("MOV    B,E")
  of 0x44:
    echo("MOV    B,H")
  of 0x45:
    echo("MOV    B,L")
  of 0x46:
    echo("MOV    B,M")
  of 0x47:
    echo("MOV    B,A")
  of 0x48:
    echo("MOV    C,B")
  of 0x49:
    echo("MOV    C,C")
  of 0x4A:
    echo("MOV    C,D")
  of 0x4B:
    echo("MOV    C,E")
  of 0x4C:
    echo("MOV    C,H")
  of 0x4D:
    echo("MOV    C,L")
  of 0x4E:
    echo("MOV    C,M")
  of 0x4F:
    echo("MOV    C,A")
  of 0x50:
    echo("MOV    D,B")
  of 0x51:
    echo("MOV    D,C")
  of 0x52:
    echo("MOV    D,D")
  of 0x53:
    echo("MOV    D.E")
  of 0x54:
    echo("MOV    D,H")
  of 0x55:
    echo("MOV    D,L")
  of 0x56:
    echo("MOV    D,M")
  of 0x57:
    echo("MOV    D,A")
  of 0x58:
    echo("MOV    E,B")
  of 0x59:
    echo("MOV    E,C")
  of 0x5A:
    echo("MOV    E,D")
  of 0x5B:
    echo("MOV    E,E")
  of 0x5C:
    echo("MOV    E,H")
  of 0x5D:
    echo("MOV    E,L")
  of 0x5E:
    echo("MOV    E,M")
  of 0x5F:
    echo("MOV    E,A")
  of 0x60:
    echo("MOV    H,B")
  of 0x61:
    echo("MOV    H,C")
  of 0x62:
    echo("MOV    H,D")
  of 0x63:
    echo("MOV    H.E")
  of 0x64:
    echo("MOV    H,H")
  of 0x65:
    echo("MOV    H,L")
  of 0x66:
    echo("MOV    H,M")
  of 0x67:
    echo("MOV    H,A")
  of 0x68:
    echo("MOV    L,B")
  of 0x69:
    echo("MOV    L,C")
  of 0x6A:
    echo("MOV    L,D")
  of 0x6B:
    echo("MOV    L,E")
  of 0x6C:
    echo("MOV    L,H")
  of 0x6D:
    echo("MOV    L,L")
  of 0x6E:
    echo("MOV    L,M")
  of 0x6F:
    echo("MOV    L,A")
  of 0x70:
    echo("MOV    M,B")
  of 0x71:
    echo("MOV    M,C")
  of 0x72:
    echo("MOV    M,D")
  of 0x73:
    echo("MOV    M.E")
  of 0x74:
    echo("MOV    M,H")
  of 0x75:
    echo("MOV    M,L")
  of 0x76:
    echo("HLT")
  of 0x77:
    echo("MOV    M,A")
  of 0x78:
    echo("MOV    A,B")
  of 0x79:
    echo("MOV    A,C")
  of 0x7A:
    echo("MOV    A,D")
  of 0x7B:
    echo("MOV    A,E")
  of 0x7C:
    echo("MOV    A,H")
  of 0x7D:
    echo("MOV    A,L")
  of 0x7E:
    echo("MOV    A,M")
  of 0x7F:
    echo("MOV    A,A")
  of 0x80:
    echo("ADD    B")
  of 0x81:
    echo("ADD    C")
  of 0x82:
    echo("ADD    D")
  of 0x83:
    echo("ADD    E")
  of 0x84:
    echo("ADD    H")
  of 0x85:
    echo("ADD    L")
  of 0x86:
    echo("ADD    M")
  of 0x87:
    echo("ADD    A")
  of 0x88:
    echo("ADC    B")
  of 0x89:
    echo("ADC    C")
  of 0x8A:
    echo("ADC    D")
  of 0x8B:
    echo("ADC    E")
  of 0x8C:
    echo("ADC    H")
  of 0x8D:
    echo("ADC    L")
  of 0x8E:
    echo("ADC    M")
  of 0x8F:
    echo("ADC    A")
  of 0x90:
    echo("SUB    B")
  of 0x91:
    echo("SUB    C")
  of 0x92:
    echo("SUB    D")
  of 0x93:
    echo("SUB    E")
  of 0x94:
    echo("SUB    H")
  of 0x95:
    echo("SUB    L")
  of 0x96:
    echo("SUB    M")
  of 0x97:
    echo("SUB    A")
  of 0x98:
    echo("SBB    B")
  of 0x99:
    echo("SBB    C")
  of 0x9A:
    echo("SBB    D")
  of 0x9B:
    echo("SBB    E")
  of 0x9C:
    echo("SBB    H")
  of 0x9D:
    echo("SBB    L")
  of 0x9E:
    echo("SBB    M")
  of 0x9F:
    echo("SBB    A")
  of 0xA0:
    echo("ANA    B")
  of 0xA1:
    echo("ANA    C")
  of 0xA2:
    echo("ANA    D")
  of 0xA3:
    echo("ANA    E")
  of 0xA4:
    echo("ANA    H")
  of 0xA5:
    echo("ANA    L")
  of 0xA6:
    echo("ANA    M")
  of 0xA7:
    echo("ANA    A")
  of 0xA8:
    echo("XRA    B")
  of 0xA9:
    echo("XRA    C")
  of 0xAA:
    echo("XRA    D")
  of 0xAB:
    echo("XRA    E")
  of 0xAC:
    echo("XRA    H")
  of 0xAD:
    echo("XRA    L")
  of 0xAE:
    echo("XRA    M")
  of 0xAF:
    echo("XRA    A")
  of 0xB0:
    echo("ORA    B")
  of 0xB1:
    echo("ORA    C")
  of 0xB2:
    echo("ORA    D")
  of 0xB3:
    echo("ORA    E")
  of 0xB4:
    echo("ORA    H")
  of 0xB5:
    echo("ORA    L")
  of 0xB6:
    echo("ORA    M")
  of 0xB7:
    echo("ORA    A")
  of 0xB8:
    echo("CMP    B")
  of 0xB9:
    echo("CMP    C")
  of 0xBA:
    echo("CMP    D")
  of 0xBB:
    echo("CMP    E")
  of 0xBC:
    echo("CMP    H")
  of 0xBD:
    echo("CMP    L")
  of 0xBE:
    echo("CMP    M")
  of 0xBF:
    echo("CMP    A")
  of 0xC0:
    echo("RNZ")
  of 0xC1:
    echo("POP    B")
  of 0xC2:
    echo("JNZ    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xC3:
    echo("JMP    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xC4:
    echo("CNZ    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xC5:
    echo("PUSH   B")
  of 0xC6:
    echo("ADI    #$%02x", (code)[1])
    opbytes = 2
  of 0xC7:
    echo("RST    0")
  of 0xC8:
    echo("RZ")
  of 0xC9:
    echo("RET")
  of 0xCA:
    echo("JZ     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xCB:
    echo("JMP    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xCC:
    echo("CZ     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xCD:
    echo("CALL   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xCE:
    echo("ACI    #$%02x", (code)[1])
    opbytes = 2
  of 0xCF:
    echo("RST    1")
  of 0xD0:
    echo("RNC")
  of 0xD1:
    echo("POP    D")
  of 0xD2:
    echo("JNC    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xD3:
    echo("OUT    #$%02x", (code)[1])
    opbytes = 2
  of 0xD4:
    echo("CNC    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xD5:
    echo("PUSH   D")
  of 0xD6:
    echo("SUI    #$%02x", (code)[1])
    opbytes = 2
  of 0xD7:
    echo("RST    2")
  of 0xD8:
    echo("RC")
  of 0xD9:
    echo("RET")
  of 0xDA:
    echo("JC     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xDB:
    echo("IN     #$%02x", (code)[1])
    opbytes = 2
  of 0xDC:
    echo("CC     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xDD:
    echo("CALL   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xDE:
    echo("SBI    #$%02x", (code)[1])
    opbytes = 2
  of 0xDF:
    echo("RST    3")
  of 0xE0:
    echo("RPO")
  of 0xE1:
    echo("POP    H")
  of 0xE2:
    echo("JPO    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xE3:
    echo("XTHL")
  of 0xE4:
    echo("CPO    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xE5:
    echo("PUSH   H")
  of 0xE6:
    echo("ANI    #$%02x", (code)[1])
    opbytes = 2
  of 0xE7:
    echo("RST    4")
  of 0xE8:
    echo("RPE")
  of 0xE9:
    echo("PCHL")
  of 0xEA:
    echo("JPE    $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xEB:
    echo("XCHG")
  of 0xEC:
    echo("CPE     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xED:
    echo("CALL   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xEE:
    echo("XRI    #$%02x", (code)[1])
    opbytes = 2
  of 0xEF:
    echo("RST    5")
  of 0xF0:
    echo("RP")
  of 0xF1:
    echo("POP    PSW")
  of 0xF2:
    echo("JP     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xF3:
    echo("DI")
  of 0xF4:
    echo("CP     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xF5:
    echo("PUSH   PSW")
  of 0xF6:
    echo("ORI    #$%02x", (code)[1])
    opbytes = 2
  of 0xF7:
    echo("RST    6")
  of 0xF8:
    echo("RM")
  of 0xF9:
    echo("SPHL")
  of 0xFA:
    echo("JM     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xFB:
    echo("EI")
  of 0xFC:
    echo("CM     $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xFD:
    echo("CALL   $%02x%02x", (code)[2], (code)[1])
    opbytes = 3
  of 0xFE:
    echo("CPI    #$%02x", (code)[1])
    opbytes = 2
  of 0xFF:
    echo("RST    7")

  return opbytes


proc parity(a: uint16, size: int): uint8 =
    var i = 0
    var p = 0
    var x: uint16 = (a and ((1 shl size)-1).uint16)
    while i<size:
        if (x and 0x1) > 0.uint16: inc(p)
        x = x shr 1
    
    return ((p and 0x1) == 0).uint8

proc addHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) + ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.cy = (answer > 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc incHandle(aState: ref state, ansArg: uint16) =
    let answer = ansArg + 1
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc inxHandle(reg1:var uint8, reg2: var uint8) =
    reg2 += 1
    if (reg2 == 0):
        reg1 += 1

proc dadHandle(aState: ref state, reg1: uint8, reg2: uint8) =
    let hl: uint32 = (aState[].h shl 8) or aState[].l
    let pair: uint32 = (reg1 shl 8) or reg2
    let res = hl + pair
    aState[].h = ((res and 0xff00) shr 8).uint8
    aState[].l = (res and 0xff).uint8
    aState[].cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

proc subHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) - ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.cy = (answer > 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc decHandle(aState: ref state, ansArg: uint16) =
    let answer = ansArg - 1
    aState[].cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState[].cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState[].cc.p = parity(answer and 0xff.uint16, 8)
    aState[].a = (answer and 0xff.uint16).uint8

proc jConditional(aState: ref state, condition: uint16, opcode: ptr uint8) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        aState[].pc = ((opcode)[2].uint16 shl 8) or (opcode)[1].uint16

proc callConditional(aState: ref state, condition: uint16, opcode: ptr uint8) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        var ret = aState[].pc+2
        (aState[].mem)[(aState[].sp-1).int] = ((ret shr 8) and 0xff).uint8
        (aState[].mem)[(aState[].sp-2).int] = (ret and 0xff).uint8
        aState[].sp -= 2
        aState[].pc = ((opcode)[2].uint16 shl 8) or (opcode)[1].uint16

proc retConditional(aState: ref state, condition: uint16, opcode: ptr uint8) =
    if (condition == 0.uint8):
        aState[].pc += 2
    else:
        aState[].pc = ((aState[].mem)[aState[].sp.int]).uint8 or ((aState[].mem)[(aState[].sp+1).int].uint8 shl 8)
        aState[].sp += 2

proc cmpHandle(aState: ref state, ansArg: uint16) =
    let answer = cast[uint16](aState[].a) - ansArg
    aState[].cc.z = ((answer and 0xff.uint16) == ansArg).uint8
    aState[].cc.cy = (answer < 0.uint16).uint8

proc ldaxHandle(aState: ref state, reg1: uint8, reg2: uint8) =
    let offset: uint16 = (reg1 shl 8) or reg2
    aState[].a = (aState[].mem)[offset.int].uint8

proc lxiHandle(aState: ref state, reg1: var uint8, reg2: var uint8, opcode: ptr uint8) =
    reg2 = (opcode)[1].uint8
    reg1 = (opcode)[2].uint8
    aState[].pc += 2

proc logicFlagsA(aState: ref state) =
    aState[].cc.cy = 0
    aState[].cc.ac = 0
    aState[].cc.z = (aState[].a == 0).uint8
    aState[].cc.p = parity(aState[].a , 8)

proc errUinmplemented() =
    echo "Instruction Unimplemented!"
    quit(1)

proc emulate8080(ourState: ref state): int =
    var opcode: ptr uint8 = addr((ourState[].mem)[ourState[].pc.int])
    discard disassemble8080(ourState[].mem, ourState[].pc.int)

    ourState[].pc += 1

    case opcode[]
    of 0x0: discard # NOP

    of 0x01: # LXI BC, Data
        lxiHandle(ourState, ourState[].b, ourState[].c, opcode)
    of 0x11: # LXI DE, Data
        lxiHandle(ourState, ourState[].d, ourState[].e, opcode)
    of 0x21: # LXI HL, data
        lxiHandle(ourState, ourState[].h, ourState[].l, opcode)
    of 0x31: # LXI SP, data
        ourState[].sp = ((opcode)[2].uint8 shl 8) or (opcode)[1].uint8
        ourState[].pc += 2

    of 0x41: ourState[].b = ourState[].c # MOV B, C
    of 0x42: ourState[].b = ourState[].d # MOV B, D
    of 0x43: ourState[].b = ourState[].e # MOV B, E
    of 0x56: # MOV D, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].d = (ourState[].mem)[offset.int].uint8
    of 0x5e: # MOV E, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].e = (ourState[].mem)[offset.int].uint8
    of 0x66: # MOV H, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].h = (ourState[].mem)[offset.int].uint8
    of 0x6f: ourState[].l = ourState[].a # MOV L, A
    of 0x77: # MOV Mem, A
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        (ourState[].mem)[offset.int] = ourState[].a
    of 0x7A: ourState[].a = ourState[].d # MOV A, D
    of 0x7B: ourState[].a = ourState[].e # MOV A, E
    of 0x7C: ourState[].a = ourState[].h # MOV A, H
    of 0x7E: # MOV A, Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        ourState[].a = (ourState[].mem)[offset.int].uint8

    of 0xA7: # ANA A
        ourState[].a = ourState[].a and ourState[].a
        logicFlagsA(ourState)
    of 0xAF: # XRA A
        if (ourState[].a and ourState[].a) > 0.uint8:
            ourState[].a = 1
        else:
            ourState[].a = 0

    of 0xd3: # OUT Data
        inc(ourState[].pc)
        # no idea wut to do

    of 0x80: # ADD B
        addHandle(ourState, cast[uint16](ourState[].b))
    of 0x81: # ADD C
        addHandle(ourState, cast[uint16](ourState[].c))
    of 0x82: # ADD D
        addHandle(ourState, cast[uint16](ourState[].d))
    of 0x83: # Add E
        addHandle(ourState, cast[uint16](ourState[].e))
    of 0x84: # Add H
        addHandle(ourState, cast[uint16](ourState[].h))
    of 0x85: # Add L
        addHandle(ourState, cast[uint16](ourState[].l))
    of 0x87: # Add A
        addHandle(ourState, cast[uint16](ourState[].a))
    of 0x86: # ADD Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = (ourState[].mem)[offset.int]
        addHandle(ourState, memArg.uint16)

    of 0x88: # ADC B
        let addCarr = cast[uint16](ourState[].b) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x89: # ADC C
        let addCarr = cast[uint16](ourState[].c) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8A: # ADC D
        let addCarr = cast[uint16](ourState[].d) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8B: # ADC E
        let addCarr = cast[uint16](ourState[].e) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8C: # ADC H
        let addCarr = cast[uint16](ourState[].h) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8D: # ADC L
        let addCarr = cast[uint16](ourState[].l) + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8E: # ADC Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let addCarr = (ourState[].mem)[offset.int].uint16 + ourState[].cc.cy
        addHandle(ourState, addCarr)
    of 0x8F: # ADC A
        let addCarr = cast[uint16](ourState[].a) + ourState[].cc.cy
        addHandle(ourState, addCarr)

    of 0x90: # SUB B
        subHandle(ourState, cast[uint16](ourState[].b))
    of 0x91: # SUB C
        subHandle(ourState, cast[uint16](ourState[].c))
    of 0x92: # SUB D
        subHandle(ourState, cast[uint16](ourState[].d))
    of 0x93: # SUB E
        subHandle(ourState, cast[uint16](ourState[].e))
    of 0x94: # SUB H
        subHandle(ourState, cast[uint16](ourState[].h))
    of 0x95: # SUB L
        subHandle(ourState, cast[uint16](ourState[].l))
    of 0x97: # SUB A
        subHandle(ourState, cast[uint16](ourState[].a))
    of 0x96: # SUB Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = (ourState[].mem)[offset.int]
        addHandle(ourState, memArg.uint16)

    of 0x98: # SBB B
        let subCarr = cast[uint16](ourState[].b) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x99: # SBB C
        let subCarr = cast[uint16](ourState[].c) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9A: # SBB D
        let subCarr = cast[uint16](ourState[].d) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9B: # SBB E
        let subCarr = cast[uint16](ourState[].e) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9C: # SBB H
        let subCarr = cast[uint16](ourState[].h) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9D: # SBB L
        let subCarr = cast[uint16](ourState[].l) - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9E: # SBB Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let subCarr = (ourState[].mem)[offset.int].uint16 - ourState[].cc.cy
        subHandle(ourState, subCarr)
    of 0x9F: # SBB A
        let subCarr = cast[uint16](ourState[].a) - ourState[].cc.cy
        subHandle(ourState, subCarr)

    of 0xC6: # ADI data
        addHandle(ourState, (opcode)[1].uint16)
    of 0xCE: # ACI data
        let addCarr = (opcode)[1].uint16 + ourState[].cc.cy
        addHandle(ourState, addCarr)

    of 0xD6: # SUI data
        subHandle(ourState, (opcode)[1].uint16)
    of 0xDE: # SBI data
        let subCarr = (opcode)[1].uint16 - ourState[].cc.cy
        subHandle(ourState, subCarr)

    of 0x04: # INR B
        incHandle(ourState, cast[uint16](ourState[].b))
    of 0x0c: # INR C
        incHandle(ourState, cast[uint16](ourState[].c))
    of 0x14: # INR D
        incHandle(ourState, cast[uint16](ourState[].d))
    of 0x1c: # INR E
        incHandle(ourState, cast[uint16](ourState[].e))
    of 0x24: # INR H
        incHandle(ourState, cast[uint16](ourState[].h))
    of 0x2c: # INR L
        incHandle(ourState, cast[uint16](ourState[].l))
    of 0x3c: # INR A
        incHandle(ourState, cast[uint16](ourState[].a))
    of 0x34: # INR Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = (ourState[].mem)[offset.int]
        incHandle(ourState, memArg.uint16)

    of 0x05: # DCR B
        decHandle(ourState, cast[uint16](ourState[].b))
    of 0x0d: # DCR C
        decHandle(ourState, cast[uint16](ourState[].c))
    of 0x15: # DCR D
        decHandle(ourState, cast[uint16](ourState[].d))
    of 0x1d: # DCR E
        decHandle(ourState, cast[uint16](ourState[].e))
    of 0x25: # DCR H
        decHandle(ourState, cast[uint16](ourState[].h))
    of 0x2d: # DCR L
        decHandle(ourState, cast[uint16](ourState[].l))
    of 0x3d: # DCR A
        decHandle(ourState, cast[uint16](ourState[].a))
    of 0x35: # DCR Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = (ourState[].mem)[offset.int]
        decHandle(ourState, memArg.uint16)

    of 0xCA: # JZ addr
        jConditional(ourState, ourState[].cc.z, opcode)
    of 0xC2: # JNZ addr
        jConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xDA: # JC addr
        jConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD2: # JNC addr
        jConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xEA: # JPE addr
        jConditional(ourState, ourState[].cc.p, opcode)
    of 0xE2: # JPO addr
        jConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xFA: # JM addr
        jConditional(ourState, ourState[].cc.s, opcode)
    of 0xF2: # JP addr
        jConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xC3: # JMP addr
        ourState[].pc = ((opcode)[2].uint16 shl 8) or (opcode)[1].uint16

    of 0xCC: # CZ addr
        callConditional(ourState, ourState[].cc.z, opcode)
    of 0xC4: # CNZ addr
        callConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xDC: # CC addr
        callConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD4: # CNC addr
        callConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xEC: # CPE addr
        callConditional(ourState, ourState[].cc.p, opcode)
    of 0xE4: # CPO addr
        callConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xFC: # CM addr
        callConditional(ourState, ourState[].cc.s, opcode)
    of 0xF4: # CP addr
        callConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xCD: # CALL addr
        var ret = ourState[].pc+2
        (ourState[].mem)[(ourState[].sp-1).int] = ((ret shr 8) and 0xff).uint8
        (ourState[].mem)[(ourState[].sp-2).int] = (ret and 0xff).uint8
        ourState[].sp -= 2
        ourState[].pc = ((opcode)[2].uint16 shl 8) or (opcode)[1].uint16

    of 0xC8: # RZ
        retConditional(ourState, ourState[].cc.z, opcode)
    of 0xC0: # RNZ
        retConditional(ourState, (not ourState[].cc.z), opcode)
    of 0xD8: # RC
        retConditional(ourState, ourState[].cc.cy, opcode)
    of 0xD0: # RNC
        retConditional(ourState, (not ourState[].cc.cy), opcode)
    of 0xE8: # RPE
        retConditional(ourState, ourState[].cc.p, opcode)
    of 0xE0: # RPO
        retConditional(ourState, (not ourState[].cc.p), opcode)
    of 0xF8: # RM
        retConditional(ourState, ourState[].cc.s, opcode)
    of 0xF0: # RP
        retConditional(ourState, (not ourState[].cc.s), opcode)
    of 0xc9: # RET
        ourState[].pc = ((ourState[].mem)[ourState[].sp.int]).uint8 or (((ourState[].mem)[(ourState[].sp+1).int]).uint8 shl 8)
        ourState[].sp += 2

    of 0x2A: # CMA (not)
        ourState[].a = not ourState[].a

    of 0xe6: # ANI byte
        let x: uint8 = ourState[].a and (opcode)[1].uint8
        ourState[].cc.z = (x == 0).uint8
        ourState[].cc.s = ((x and 0x80.uint8) == 0x80).uint8
        ourState[].cc.p = parity(x, 8)
        ourState[].cc.cy = 0
        ourState[].a = x
        ourState[].pc += 1
    
    of 0x0F: # RRC
        let x: uint8 = ourState[].a
        ourState[].a = ((x and 1) shl 7) or (x shr 1)
        ourState[].cc.cy = ((x and 1) == 1).uint8
    of 0x1F: # RAR
        let x: uint8 = ourState[].a
        ourState[].a = (ourState[].cc.cy shl 7) or (x shr 1)
        ourState[].cc.cy = ((x and 1) == 1).uint8
    
    of 0xb8: # CMP B
        cmpHandle(ourState, cast[uint16](ourState[].b))
    of 0xb9: # CMP C
        cmpHandle(ourState, cast[uint16](ourState[].c))
    of 0xbA: # CMP D
        cmpHandle(ourState, cast[uint16](ourState[].d))
    of 0xBB: # CMP E
        cmpHandle(ourState, cast[uint16](ourState[].e))
    of 0xBC: # CMP H
        cmpHandle(ourState, cast[uint16](ourState[].h))
    of 0xBD: # CMP L
        cmpHandle(ourState, cast[uint16](ourState[].l))
    of 0xBF: # CMP A
        cmpHandle(ourState, cast[uint16](ourState[].a))
    of 0xBE: # CMP Mem
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        let memArg = (ourState[].mem)[offset.int]
        cmpHandle(ourState, memArg.uint16)

    of 0xFE: # CPI byte
        let x = ourState[].a - (opcode)[1].uint8
        ourState[].cc.z = (x == 0).uint8
        ourState[].cc.s = ((x and 0x80) == 0x80.uint8).uint8
        ourState[].cc.p = parity(x, 8)
        ourState[].cc.cy = (ourState[].a < (opcode)[1].uint8).uint8
        ourState[].pc += 1

    of 0x3F: # CMC
        ourState[].cc.cy = not ourState[].cc.cy
    of 0x37: # STC
        ourState[].cc.cy = 1
    
    of 0x76: # HLT
        quit(0)
    
    of 0xC1: # POP BC
        ourState[].c = (ourState[].mem)[ourState[].sp.int].uint8
        ourState[].c = (ourState[].mem)[(ourState[].sp+1).int].uint8
        ourState[].sp += 2
    of 0xD1: # POP DE
        ourState[].d = (ourState[].mem)[ourState[].sp.int].uint8
        ourState[].e = (ourState[].mem)[(ourState[].sp+1).int].uint8
        ourState[].sp += 2
    of 0xE1: # POP HL
        ourState[].h = (ourState[].mem)[ourState[].sp.int].uint8
        ourState[].l = (ourState[].mem)[(ourState[].sp+1).int].uint8
        ourState[].sp += 2
    of 0xf1: # POP PSW
        ourState[].a = (ourState[].mem)[(ourState[].sp+1).int].uint8
        let psw: uint8 = (ourState[].mem)[ourState[].sp.int].uint8
        ourState[].cc.z = ((psw and 0x01) == 0x01).uint8
        ourState[].cc.s = ((psw and 0x02) == 0x02).uint8
        ourState[].cc.p = ((psw and 0x04) == 0x04).uint8
        ourState[].cc.cy = ((psw and 0x08) == 0x05).uint8
        ourState[].cc.cy = ((psw and 0x10) == 0x10).uint8
        ourState[].sp += 2

    of 0xC5: # PUSH BC
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].b
        (ourState[].mem)[(ourState[].sp-2).int] = ourState[].c
        ourState[].sp -= 2
    of 0xD5: # PUSH DE
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].d
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].e
        ourState[].sp -= 2
    of 0xE5: # PUSH HL
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].h
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].l
        ourState[].sp -= 2
    of 0xF5: # PUSH PSW
        (ourState[].mem)[(ourState[].sp-1).int] = ourState[].a
        let psw: uint8 = (ourState[].cc.z or
           ourState[].cc.s shl 1 or
           ourState[].cc.p shl 2 or 
           ourState[].cc.cy shl 3 or
           ourState[].cc.ac shl 4)
        (ourState[].mem)[(ourState[].sp-2).int] = psw
        ourState[].sp -= 2

    of 0xf9: # SPHL
        ourState[].sp = (ourState[].h shl 8) or (ourState[].l)
    
    of 0x06: # MVI B, data
        ourState[].b = (opcode)[1]
        ourState[].pc += 2
    of 0x0e: # MVI C, data
        ourState[].c = (opcode)[1]
        ourState[].pc += 2
    of 0x16: # MVI D, data
        ourState[].d = (opcode)[1]
        ourState[].pc += 2
    of 0x1e: # MVI E, data
        ourState[].e = (opcode)[1]
        ourState[].pc += 2
    of 0x26: # MVI H, data
        ourState[].h = (opcode)[1]
        ourState[].pc += 2
    of 0x2e: # MVI L, data
        ourState[].l = (opcode)[1]
        ourState[].pc += 2
    of 0x36: # MVI Mem, data
        let offset: uint8 = (ourState[].h shl 8) or (ourState[].l)
        (ourState[].mem)[offset.int] = (opcode)[1]
        ourState[].pc += 2
    of 0x3e: # MVI A, data
        ourState[].a = (opcode)[1].uint8
        ourState[].pc += 2

    of 0x09: # DAD BC
        dadHandle(ourState, ourState[].b, ourState[].c)
    of 0x19: # DAD DE
        dadHandle(ourState, ourState[].d, ourState[].e)
    of 0x29: # DAD HL
        dadHandle(ourState, ourState[].h, ourState[].l)
    of 0x39: # DAD SP
        let hl: uint32 = (ourState[].h shl 8) or ourState[].l
        let res = hl + ourState[].sp
        ourState[].h = ((res and 0xff00) shr 8).uint8
        ourState[].l = (res and 0xff).uint8
        ourState[].cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

    of 0x03: # INX BC
        inxHandle(ourState[].b, ourState[].c)
    of 0x13: # INX DE
        inxHandle(ourState[].d, ourState[].e)
    of 0x23: # INX HL
        inxHandle(ourState[].h, ourState[].l)

    of 0x0a: # LDAX BC
        ldaxHandle(ourState, ourState[].b, ourState[].c)
    of 0x1a: # LDAX DE
        ldaxHandle(ourState, ourState[].d, ourState[].e)
    
    of 0x32: # STA addr
        let offset = ((opcode)[2].uint8 shl 8) or (opcode)[1].uint8
        (ourState[].mem)[offset.int] = ourState[].a
        ourState[].pc += 2
    of 0x3a: # LDA addr
        let offset = ((opcode)[2].uint8 shl 8) or (opcode)[1].uint8
        ourState[].a = (ourState[].mem)[offset.int].uint8
        ourState[].pc += 2
    
    of 0xEB: # XCHG
        let reg1 = ourState[].d
        let reg2 = ourState[].e
        ourState[].d = ourState[].h
        ourState[].e = ourState[].l
        ourState[].h = reg1
        ourState[].l = reg2

    of 0xFB: # EI
            ourState[].intEnable = 1

    else:
        errUinmplemented()
        echo "OPCode=" & $opcode[]

    echo "Cmds=" & $ourState[].cc
    echo "state=" & $ourState[]
    return 1
    #[TODO:
        INX SP - Unsure how to
        DCX - Lazy
        RST - Too lazy to add all of them. Space invaders doesn't use it anyways
        PCHL - Dunno how to assign to PCH and PCL
        IO/Special Groups - Not at that stage
        XTHL - useless
    ]#

# to do, borked
proc readToMem(ourState: ref state, filename: string) =
    let file = newFileStream(filename, fmWrite)
    discard readData(file, (addr((ourState[].mem)[0])), 8)
    file.close
# to do
proc main() =
    var done = 0
    var vblankcycles = 0
    var ourState = new(ref state)

    readToMem(ourState, "rom/invaders.rom")

    while done == 0:
        done = emulate8080(ourState)


main()