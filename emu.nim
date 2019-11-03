#[
Copyright (c) Rupansh Sekar. All rights reserved.
Licensed under the MIT license. See LICENSE file in the project root for details.
]#

import sdl2/sdl
import streams
import threadpool

type
  conditionCodes* = object
    z* {.bitsize: 1.}: uint8
    s* {.bitsize: 1.}: uint8
    p* {.bitsize: 1.}: uint8
    cy* {.bitsize: 1.}: uint8
    ac* {.bitsize: 1.}: uint8 # unused for space invaders
    pad* {.bitsize: 3.}: uint8

  state* = object
    a*: uint8
    b*: uint8
    c*: uint8
    d*: uint8
    e*: uint8
    h*: uint8
    l*: uint8
    sp*: uint16
    pc*: uint16
    mem*: seq[byte]
    cc*: conditionCodes
    intEnable*: uint8

proc `$`(x: byte): string =
    $x.int


proc disassemble8080(code: seq[byte]; pc: uint16): int =
  var opbytes: int = 1
  echo("PC = " & $pc)
  case code[pc]
  of 0x00:
    echo("NOP")
  of 0x01:
    echo("LXI    B," & $code[pc + 2].int & $code[pc + 1].int)
    opbytes = 3
  of 0x02:
    echo("STAX   B")
  of 0x03:
    echo("INX    B")
  of 0x04:
    echo("INR    B")
  of 0x05:
    echo("DCR   B=" & $code[pc+1].int)
  of 0x06:
    echo("MVI    B," & $code[pc + 1].int)
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
    echo("MVI    C," & $code[pc + 1].int)
    opbytes = 2
  of 0x0F:
    echo("RRC")
  of 0x10:
    echo("NOP")
  of 0x11:
    echo("LXI    D," & $code[pc + 2].int & $code[pc + 1].int)
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
    echo("MVI    D" & $code[pc + 1].int)
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
    echo("MVI    E" & $code[pc + 1].int)
    opbytes = 2
  of 0x1F:
    echo("RAR")
  of 0x20:
    echo("NOP")
  of 0x21:
    echo("LXI    H," & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x22:
    echo("SHLD   " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x23:
    echo("INX    H")
  of 0x24:
    echo("INR    H")
  of 0x25:
    echo("DCR    H")
  of 0x26:
    echo("MVI    H," & $code[pc + 1])
    opbytes = 2
  of 0x27:
    echo("DAA")
  of 0x28:
    echo("NOP")
  of 0x29:
    echo("DAD    H")
  of 0x2A:
    echo("LHLD   " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x2B:
    echo("DCX    H")
  of 0x2C:
    echo("INR    L")
  of 0x2D:
    echo("DCR    L")
  of 0x2E:
    echo("MVI    L," & $code[pc + 1])
    opbytes = 2
  of 0x2F:
    echo("CMA")
  of 0x30:
    echo("NOP")
  of 0x31:
    echo("LXI    SP," & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x32:
    echo("STA    $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x33:
    echo("INX    SP")
  of 0x34:
    echo("INR    M")
  of 0x35:
    echo("DCR    M")
  of 0x36:
    echo("MVI    M," & $code[pc + 1])
    opbytes = 2
  of 0x37:
    echo("STC")
  of 0x38:
    echo("NOP")
  of 0x39:
    echo("DAD    SP")
  of 0x3A:
    echo("LDA    " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0x3B:
    echo("DCX    SP")
  of 0x3C:
    echo("INR    A")
  of 0x3D:
    echo("DCR    A")
  of 0x3E:
    echo("MVI    A" & $code[pc + 1])
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
    echo("JNZ    " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xC3:
    echo("JMP    " & $code[pc + 2], $code[pc + 1])
    opbytes = 3
  of 0xC4:
    echo("CNZ    " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xC5:
    echo("PUSH   B")
  of 0xC6:
    echo("ADI    " & $code[pc + 1])
    opbytes = 2
  of 0xC7:
    echo("RST    0")
  of 0xC8:
    echo("RZ")
  of 0xC9:
    echo("RET")
  of 0xCA:
    echo("JZ     $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xCB:
    echo("JMP    $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xCC:
    echo("CZ     $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xCD:
    echo("CALL   $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xCE:
    echo("ACI    " & $code[pc + 1])
    opbytes = 2
  of 0xCF:
    echo("RST    1")
  of 0xD0:
    echo("RNC")
  of 0xD1:
    echo("POP    D")
  of 0xD2:
    echo("JNC    $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xD3:
    echo("OUT    #" & $code[pc + 1])
    opbytes = 2
  of 0xD4:
    echo("CNC    $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xD5:
    echo("PUSH   D")
  of 0xD6:
    echo("SUI    #" & $code[pc + 1])
    opbytes = 2
  of 0xD7:
    echo("RST    2")
  of 0xD8:
    echo("RC")
  of 0xD9:
    echo("RET")
  of 0xDA:
    echo("JC     " & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xDB:
    echo("IN     #" & $code[pc + 1])
    opbytes = 2
  of 0xDC:
    echo("CC     $" & $code[pc + 2] & $code[pc + 1])
    opbytes = 3
  of 0xDD:
    echo("CALL   $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xDE:
    echo("SBI    #$%02x", code[pc + 1])
    opbytes = 2
  of 0xDF:
    echo("RST    3")
  of 0xE0:
    echo("RPO")
  of 0xE1:
    echo("POP    H")
  of 0xE2:
    echo("JPO    $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xE3:
    echo("XTHL")
  of 0xE4:
    echo("CPO    $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xE5:
    echo("PUSH   H")
  of 0xE6:
    echo("ANI    #" & $code[pc + 1])
    opbytes = 2
  of 0xE7:
    echo("RST    4")
  of 0xE8:
    echo("RPE")
  of 0xE9:
    echo("PCHL")
  of 0xEA:
    echo("JPE    $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xEB:
    echo("XCHG")
  of 0xEC:
    echo("CPE     $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xED:
    echo("CALL   $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xEE:
    echo("XRI    #$%02x", code[pc + 1])
    opbytes = 2
  of 0xEF:
    echo("RST    5")
  of 0xF0:
    echo("RP")
  of 0xF1:
    echo("POP    PSW")
  of 0xF2:
    echo("JP     $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xF3:
    echo("DI")
  of 0xF4:
    echo("CP     $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xF5:
    echo("PUSH   PSW")
  of 0xF6:
    echo("ORI    #$%02x", code[pc + 1])
    opbytes = 2
  of 0xF7:
    echo("RST    6")
  of 0xF8:
    echo("RM")
  of 0xF9:
    echo("SPHL")
  of 0xFA:
    echo("JM     $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xFB:
    echo("EI")
  of 0xFC:
    echo("CM     $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xFD:
    echo("CALL   $%02x%02x", code[pc + 2], code[pc + 1])
    opbytes = 3
  of 0xFE:
    echo("CPI    #$%02x", code[pc + 1])
    opbytes = 2
  of 0xFF:
    echo("RST    7")

  return opbytes


proc parity(a: int, size: int): int =
    var i = 0
    var p = 0
    var x = (a and ((1 shl size)-1))
    while i<size:
        if (x and 0x1) > 0: inc(p)
        x = x shr 1
        inc(i)
    
    return ((p and 0x1) == 0).int

proc addHandle(aState: var state, ansArg: uint16) =
    let answer = cast[uint16](aState.a) + ansArg
    aState.cc.z = ((answer and 0xff) == 0.uint16).uint8
    aState.cc.s = ((answer and 0x80) != 0.uint16).uint8
    aState.cc.cy = (answer > 0.uint16).uint8
    aState.cc.p = parity((answer and 0xff).int, 8).uint8
    aState.a = (answer and 0xff).uint8

proc incHandle(aState: var state, ansArg: var uint8) =
    let answer = ansArg + 1
    aState.cc.z = (answer == 0.uint8).uint8
    aState.cc.s = ((answer and 0x80.uint8) == 0x80.uint8).uint8
    aState.cc.p = parity(answer.int, 8).uint8
    ansArg = (answer).uint8

proc inxHandle(reg1:var uint8, reg2: var uint8) =
    reg2 += 1
    if (reg2 == 0):
        reg1 += 1

proc dadHandle(aState: var state, reg1: uint8, reg2: uint8) =
    let hl: uint32 = (aState.h.uint32 shl 8) or aState.l
    let pair: uint32 = (reg1.uint32 shl 8) or reg2
    let res = hl + pair
    aState.h = ((res and 0xff00) shr 8).uint8
    aState.l = (res and 0xff).uint8
    aState.cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

proc subHandle(aState: var state, ansArg: uint16) =
    let answer = cast[uint16](aState.a) - ansArg
    aState.cc.z = ((answer and 0xff.uint16) == 0.uint16).uint8
    aState.cc.s = ((answer and 0x80.uint16) != 0.uint16).uint8
    aState.cc.cy = (answer > 0.uint16).uint8
    aState.cc.p = parity((answer and 0xff).int, 8).uint8
    aState.a = (answer and 0xff.uint16).uint8

proc decHandle(aState: var state, ansArg: var uint8) =
    let answer = ansArg - 1.uint8
    aState.cc.z = (answer == 0.uint8).uint8
    aState.cc.s = ((answer and 0x80) == 0x80).uint8
    aState.cc.p = parity(answer.int, 8).uint8
    ansArg = answer
    echo(answer.int)
    echo(ansArg.int)

proc dcxHandle(reg1:var uint8, reg2: var uint8) =
    if reg2 == 0:
        reg2 = 255
    else:
        reg2 -= 1
    if (reg2 == 0):
        if reg1 == 0:
            reg1 = 255
        else:
            reg1 -= 1

proc jConditional(aState: var state, condition: uint8, opcode: var seq[byte]) =
    if (condition == 254.uint8):
        aState.pc += 3
    else:
        aState.pc = (opcode[aState.pc + 2].uint16 shl 8) or opcode[aState.pc + 1]

proc callConditional(aState: var state, condition: uint16, opcode: var seq[byte]) =
    if (condition == 254.uint8):
        aState.pc += 3
    else:
        var ret = aState.pc+2
        (aState.mem)[(aState.sp-1)] = ((ret shr 8) and 0xff).uint8
        (aState.mem)[(aState.sp-2)] = (ret and 0xff).uint8
        aState.sp -= 2
        aState.pc = (opcode[aState.pc + 2].uint16 shl 8) or opcode[aState.pc + 1].uint16

proc retConditional(aState: var state, condition: uint16, opcode: var seq[byte]) =
    if (condition == 254.uint8):
        aState.pc += 3
    else:
        aState.pc = ((aState.mem)[aState.sp]).uint16 or ((aState.mem)[(aState.sp+1)].uint16 shl 8)
        aState.sp += 2

proc cmpHandle(aState: var state, ansArg: uint16) =
    let answer = cast[uint16](aState.a) - ansArg
    aState.cc.z = ((answer and 0xff.uint16) == ansArg).uint8
    aState.cc.cy = (answer < 0.uint16).uint8

proc ldaxHandle(aState: var state, reg1: uint8, reg2: uint8) =
    let offset: uint16 = (reg1.uint16 shl 8) or reg2
    aState.a = (aState.mem)[offset].uint8

proc lxiHandle(aState: var state, reg1: var uint8, reg2: var uint8, opcode: var seq[byte]) =
    reg2 = opcode[aState.pc + 1]
    reg1 = opcode[aState.pc + 2]
    aState.pc += 3

proc logicFlagsA(aState: var state) =
    aState.cc.cy = 0
    aState.cc.ac = 0
    aState.cc.z = (aState.a == 0).uint8
    aState.cc.s = ((aState.a and 0x80) == 0x80).uint8
    aState.cc.p = parity(aState.a.int , 8).uint8

proc errUinmplemented() =
    echo "Instruction Unimplemented!"
    quit(1)

proc emulate8080(ourState: var state): int =
    var opcode: seq[uint8] = ourState.mem
    discard disassemble8080(opcode, ourState.pc)


    case opcode[ourState.pc]
    of 0x0: discard # NOP
    of 0x20: discard # NOP
    of 0x08: discard # NOP

    of 0x01: # LXI BC, Data
        lxiHandle(ourState, ourState.b, ourState.c, opcode)
    of 0x11: # LXI DE, Data
        lxiHandle(ourState, ourState.d, ourState.e, opcode)
    of 0x21: # LXI HL, data
        lxiHandle(ourState, ourState.h, ourState.l, opcode)
    of 0x31: # LXI SP, data
        ourState.sp = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1]
        ourState.pc += 3

    of 0x41: ourState.b = ourState.c # MOV B, C
    of 0x42: ourState.b = ourState.d # MOV B, D
    of 0x43: ourState.b = ourState.e # MOV B, E
    of 0x46: # MOV B, Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.b = ourState.mem[offset].uint8
    of 0x56: # MOV D, Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.d = ourState.mem[offset].uint8
    of 0x5e: # MOV E, Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.e = ourState.mem[offset].uint8
    of 0x66: # MOV H, Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.h = ourState.mem[offset].uint8
    of 0x6f: ourState.l = ourState.a # MOV L, A
    of 0x77: # MOV Mem, A
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.mem[offset] = ourState.a
    of 0x79: ourState.a = ourState.c # MOV A, C
    of 0x7A: ourState.a = ourState.d # MOV A, D
    of 0x7B: ourState.a = ourState.e # MOV A, E
    of 0x7C: ourState.a = ourState.h # MOV A, H
    of 0x7E: # MOV A, Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.a = ourState.mem[offset].uint8
    of 0x4F: ourState.c = ourState.a # MOV C, A
    of 0x67: ourState.h = ourState.a # MOV H, A

    of 0xA7: # ANA A
        ourState.a = ourState.a and ourState.a
        logicFlagsA(ourState)
    of 0xAF: # XRA A
        if (ourState.a and ourState.a) > 0.uint8:
            ourState.a = 1
        else:
            ourState.a = 0
        logicFlagsA(ourState)
    of 0xB0: # ORA B
      ourState.a = ourState.a or ourState.b
      logicFlagsA(ourState)

    of 0xd3: # OUT Data
        inc(ourState.pc)
        # no idea wut to do
    of 0xDB: # IN Data
        inc(ourState.pc)
        # onk

    of 0x80: # ADD B
        addHandle(ourState, cast[uint16](ourState.b))
    of 0x81: # ADD C
        addHandle(ourState, cast[uint16](ourState.c))
    of 0x82: # ADD D
        addHandle(ourState, cast[uint16](ourState.d))
    of 0x83: # Add E
        addHandle(ourState, cast[uint16](ourState.e))
    of 0x84: # Add H
        addHandle(ourState, cast[uint16](ourState.h))
    of 0x85: # Add L
        addHandle(ourState, cast[uint16](ourState.l))
    of 0x87: # Add A
        addHandle(ourState, cast[uint16](ourState.a))
    of 0x86: # ADD Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        let memArg = ourState.mem[offset]
        addHandle(ourState, memArg.uint16)

    of 0x88: # ADC B
        let addCarr = cast[uint16](ourState.b) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x89: # ADC C
        let addCarr = cast[uint16](ourState.c) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8A: # ADC D
        let addCarr = cast[uint16](ourState.d) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8B: # ADC E
        let addCarr = cast[uint16](ourState.e) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8C: # ADC H
        let addCarr = cast[uint16](ourState.h) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8D: # ADC L
        let addCarr = cast[uint16](ourState.l) + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8E: # ADC Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        let addCarr = ourState.mem[offset].uint16 + ourState.cc.cy
        addHandle(ourState, addCarr)
    of 0x8F: # ADC A
        let addCarr = cast[uint16](ourState.a) + ourState.cc.cy
        addHandle(ourState, addCarr)

    of 0x90: # SUB B
        subHandle(ourState, cast[uint16](ourState.b))
    of 0x91: # SUB C
        subHandle(ourState, cast[uint16](ourState.c))
    of 0x92: # SUB D
        subHandle(ourState, cast[uint16](ourState.d))
    of 0x93: # SUB E
        subHandle(ourState, cast[uint16](ourState.e))
    of 0x94: # SUB H
        subHandle(ourState, cast[uint16](ourState.h))
    of 0x95: # SUB L
        subHandle(ourState, cast[uint16](ourState.l))
    of 0x97: # SUB A
        subHandle(ourState, cast[uint16](ourState.a))
    of 0x96: # SUB Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        let memArg = ourState.mem[offset]
        addHandle(ourState, memArg.uint16)

    of 0x98: # SBB B
        let subCarr = cast[uint16](ourState.b) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x99: # SBB C
        let subCarr = cast[uint16](ourState.c) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9A: # SBB D
        let subCarr = cast[uint16](ourState.d) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9B: # SBB E
        let subCarr = cast[uint16](ourState.e) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9C: # SBB H
        let subCarr = cast[uint16](ourState.h) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9D: # SBB L
        let subCarr = cast[uint16](ourState.l) - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9E: # SBB Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        let subCarr = ourState.mem[offset] - ourState.cc.cy
        subHandle(ourState, subCarr)
    of 0x9F: # SBB A
        let subCarr = cast[uint16](ourState.a) - ourState.cc.cy
        subHandle(ourState, subCarr)

    of 0xC6: # ADI data
        let answer = cast[uint16](ourState.a) + opcode[ourState.pc + 1].uint16
        ourState.cc.z = ((answer and 0xff) == 0.uint16).uint8
        ourState.cc.s = ((answer and 0x80) == 0x80.uint16).uint8
        ourState.cc.cy = (answer > 0.uint16).uint8
        ourState.cc.p = parity((answer and 0xff).int, 8).uint8
        ourState.a = (answer and 0xff).uint8
    of 0xCE: # ACI data
        let addCarr = opcode[ourState.pc + 1].uint16 + ourState.cc.cy
        addHandle(ourState, addCarr)

    of 0xD6: # SUI data
        subHandle(ourState, opcode[ourState.pc + 1].uint16)
    of 0xDE: # SBI data
        let subCarr = opcode[ourState.pc + 1].uint16 - ourState.cc.cy
        subHandle(ourState, subCarr)

    of 0x04: # INR B
        incHandle(ourState, ourState.b)
    of 0x0c: # INR C
        incHandle(ourState, ourState.c)
    of 0x14: # INR D
        incHandle(ourState, ourState.d)
    of 0x1c: # INR E
        incHandle(ourState, ourState.e)
    of 0x24: # INR H
        incHandle(ourState, ourState.h)
    of 0x2c: # INR L
        incHandle(ourState, ourState.l)
    of 0x3c: # INR A
        incHandle(ourState, ourState.a)
    of 0x34: # INR Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        incHandle(ourState, ourState.mem[offset])

    of 0x05: # DCR B
        decHandle(ourState, ourState.b)
    of 0x0d: # DCR C
        decHandle(ourState, ourState.c)
    of 0x15: # DCR D
        decHandle(ourState, ourState.d)
    of 0x1d: # DCR E
        decHandle(ourState, ourState.e)
    of 0x25: # DCR H
        decHandle(ourState, ourState.h)
    of 0x2d: # DCR L
        decHandle(ourState, ourState.l)
    of 0x3d: # DCR A
        decHandle(ourState, ourState.a)
    of 0x35: # DCR Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        decHandle(ourState, ourState.mem[offset])

    of 0xCA: # JZ addr
        jConditional(ourState, ourState.cc.z, opcode)
    of 0xC2: # JNZ addr
        echo(ourState.cc.z.int)
        echo((not ourState.cc.z).int)
        jConditional(ourState, (not ourState.cc.z), opcode)
    of 0xDA: # JC addr
        jConditional(ourState, ourState.cc.cy, opcode)
    of 0xD2: # JNC addr
        jConditional(ourState, (not ourState.cc.cy), opcode)
    of 0xEA: # JPE addr
        jConditional(ourState, ourState.cc.p, opcode)
    of 0xE2: # JPO addr
        jConditional(ourState, (not ourState.cc.p), opcode)
    of 0xFA: # JM addr
        jConditional(ourState, ourState.cc.s, opcode)
    of 0xF2: # JP addr
        jConditional(ourState, (not ourState.cc.s), opcode)
    of 0xC3: # JMP addr
        ourState.pc = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1]

    of 0xCC: # CZ addr
        callConditional(ourState, ourState.cc.z, opcode)
    of 0xC4: # CNZ addr
        callConditional(ourState, (not ourState.cc.z), opcode)
    of 0xDC: # CC addr
        callConditional(ourState, ourState.cc.cy, opcode)
    of 0xD4: # CNC addr
        callConditional(ourState, (not ourState.cc.cy), opcode)
    of 0xEC: # CPE addr
        callConditional(ourState, ourState.cc.p, opcode)
    of 0xE4: # CPO addr
        callConditional(ourState, (not ourState.cc.p), opcode)
    of 0xFC: # CM addr
        callConditional(ourState, ourState.cc.s, opcode)
    of 0xF4: # CP addr
        callConditional(ourState, (not ourState.cc.s), opcode)
    of 0xCD: # CALL addr
        var ret = ourState.pc+2
        ourState.mem[ourState.sp-1] = ((ret shr 8) and 0xff).uint8
        ourState.mem[ourState.sp-2] = (ret and 0xff).uint8
        ourState.sp -= 2
        ourState.pc = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1].uint16

    of 0xC8: # RZ
        retConditional(ourState, ourState.cc.z, opcode)
    of 0xC0: # RNZ
        retConditional(ourState, (not ourState.cc.z), opcode)
    of 0xD8: # RC
        retConditional(ourState, ourState.cc.cy, opcode)
    of 0xD0: # RNC
        retConditional(ourState, (not ourState.cc.cy), opcode)
    of 0xE8: # RPE
        retConditional(ourState, ourState.cc.p, opcode)
    of 0xE0: # RPO
        retConditional(ourState, (not ourState.cc.p), opcode)
    of 0xF8: # RM
        retConditional(ourState, ourState.cc.s, opcode)
    of 0xF0: # RP
        retConditional(ourState, (not ourState.cc.s), opcode)
    of 0xc9: # RET
        ourState.pc = ourState.mem[ourState.sp].uint16 or (ourState.mem[ourState.sp+1].uint16 shl 8)
        ourState.sp += 2

    of 0x2A: # CMA (not)
        ourState.a = not ourState.a

    of 0xe6: # ANI byte
        ourState.a = ourState.a and opcode[ourState.pc + 1]
        logicFlagsA(ourState)
        ourState.pc += 2
    
    of 0x0F: # RRC
        let x: uint8 = ourState.a
        ourState.a = (((x and 1).uint16 shl 7) or (x shr 1)).uint8
        ourState.cc.cy = ((x and 1) == 1).uint8
    of 0x1F: # RAR
        let x: uint8 = ourState.a
        ourState.a = ((ourState.cc.cy.uint16 shl 7) or (x shr 1)).uint8
        ourState.cc.cy = ((x and 1) == 1).uint8
    
    of 0xb8: # CMP B
        cmpHandle(ourState, cast[uint16](ourState.b))
    of 0xb9: # CMP C
        cmpHandle(ourState, cast[uint16](ourState.c))
    of 0xbA: # CMP D
        cmpHandle(ourState, cast[uint16](ourState.d))
    of 0xBB: # CMP E
        cmpHandle(ourState, cast[uint16](ourState.e))
    of 0xBC: # CMP H
        cmpHandle(ourState, cast[uint16](ourState.h))
    of 0xBD: # CMP L
        cmpHandle(ourState, cast[uint16](ourState.l))
    of 0xBF: # CMP A
        cmpHandle(ourState, cast[uint16](ourState.a))
    of 0xBE: # CMP Mem
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        let memArg = ourState.mem[offset]
        cmpHandle(ourState, memArg.uint16)

    of 0xFE: # CPI byte
        let x: uint8 = ourState.a - opcode[ourState.pc + 1]
        ourState.cc.z = (x == 0).uint8
        ourState.cc.s = ((x and 0x80) == 0x80).uint8
        ourState.cc.p = parity(x.int, 8).uint8
        ourState.cc.cy = (ourState.a < opcode[ourState.pc + 1]).uint8
        ourState.pc += 2

    of 0x3F: # CMC
        ourState.cc.cy = not ourState.cc.cy
    of 0x37: # STC
        ourState.cc.cy = 1
    
    of 0x76: # HLT
        quit(0)
    
    of 0xC1: # POP BC
        ourState.c = ourState.mem[ourState.sp]
        ourState.b = ourState.mem[ourState.sp+1]
        ourState.sp += 2
    of 0xD1: # POP DE
        ourState.e = ourState.mem[ourState.sp]
        ourState.d = ourState.mem[ourState.sp+1]
        ourState.sp += 2
    of 0xE1: # POP HL
        ourState.l = ourState.mem[ourState.sp]
        ourState.h = ourState.mem[ourState.sp+1]
        ourState.sp += 2
    of 0xf1: # POP PSW
        ourState.a = ourState.mem[ourState.sp+1]
        let psw: uint8 = ourState.mem[ourState.sp]
        ourState.cc.z = ((psw and 0x01) == 0x01).uint8
        ourState.cc.s = ((psw and 0x02) == 0x02).uint8
        ourState.cc.p = ((psw and 0x04) == 0x04).uint8
        ourState.cc.cy = ((psw and 0x08) == 0x05).uint8
        ourState.cc.ac = ((psw and 0x10) == 0x10).uint8
        ourState.sp += 2

    of 0xC5: # PUSH BC
        ourState.mem[ourState.sp-1] = ourState.b
        ourState.mem[ourState.sp-2] = ourState.c
        ourState.sp -= 2
    of 0xD5: # PUSH DE
        ourState.mem[ourState.sp-1] = ourState.d
        ourState.mem[ourState.sp-2] = ourState.e
        ourState.sp -= 2
    of 0xE5: # PUSH HL
        ourState.mem[ourState.sp-1] = ourState.h
        ourState.mem[ourState.sp-2] = ourState.l
        ourState.sp -= 2
    of 0xF5: # PUSH PSW
        ourState.mem[ourState.sp-1] = ourState.a
        let psw: uint8 = (ourState.cc.z or
           ourState.cc.s shl 1 or
           ourState.cc.p shl 2 or 
           ourState.cc.cy shl 3 or
           ourState.cc.ac shl 4)
        ourState.mem[ourState.sp-2] = psw
        ourState.sp -= 2

    of 0xf9: # SPHL
        ourState.sp = (ourState.h.uint16 shl 8) or (ourState.l)
    
    of 0x06: # MVI B, data
        ourState.b = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x0e: # MVI C, data
        ourState.c = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x16: # MVI D, data
        ourState.d = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x1e: # MVI E, data
        ourState.e = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x26: # MVI H, data
        ourState.h = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x2e: # MVI L, data
        ourState.l = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x36: # MVI Mem, data
        let offset: uint16 = (ourState.h.uint16 shl 8) or (ourState.l)
        ourState.mem[offset] = opcode[ourState.pc + 1]
        ourState.pc += 2
    of 0x3e: # MVI A, data
        ourState.a = opcode[ourState.pc + 1]
        ourState.pc += 2

    of 0x09: # DAD BC
        dadHandle(ourState, ourState.b, ourState.c)
    of 0x19: # DAD DE
        dadHandle(ourState, ourState.d, ourState.e)
    of 0x29: # DAD HL
        dadHandle(ourState, ourState.h, ourState.l)
    of 0x39: # DAD SP
        let hl: uint32 = (ourState.h.uint16 shl 8) or ourState.l
        let res = hl + ourState.sp
        ourState.h = ((res and 0xff00) shr 8).uint8
        ourState.l = (res and 0xff).uint8
        ourState.cc.cy = ((res and 0xffff0000.uint32) > 0.uint32).uint8

    of 0x03: # INX BC
        inxHandle(ourState.b, ourState.c)
    of 0x13: # INX DE
        inxHandle(ourState.d, ourState.e)
    of 0x23: # INX HL
        inxHandle(ourState.h, ourState.l)

    of 0x0a: # LDAX BC
        ldaxHandle(ourState, ourState.b, ourState.c)
    of 0x1a: # LDAX DE
        ldaxHandle(ourState, ourState.d, ourState.e)

    of 0x22: # SHLD addr
        let offset: uint16 = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1]
        ourState.mem[offset] = ourState.l
        ourState.mem[offset+1] = ourState.h
        ourState.pc += 3
    of 0x32: # STA addr
        let offset: uint16 = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1]
        ourState.mem[offset] = ourState.a
        ourState.pc += 3
    of 0x3a: # LDA addr
        let offset: uint16 = (opcode[ourState.pc + 2].uint16 shl 8) or opcode[ourState.pc + 1]
        ourState.a = ourState.mem[offset]
        ourState.pc += 3
    
    of 0xEB: # XCHG
        let reg1 = ourState.d
        let reg2 = ourState.e
        ourState.d = ourState.h
        ourState.e = ourState.l
        ourState.h = reg1
        ourState.l = reg2

    of 0xFB: # EI
            ourState.intEnable = 1
    
    of 0x2B: # DCX
        dcxHandle(ourState.h, ourState.l)

    else:
        echo "OPCode=" & $opcode[ourState.pc]
        errUinmplemented()

    return 0
    #[TODO:
        INX SP - Unsure how to
        DCX - Lazy
        RST - Too lazy to add all of them. Space invaders doesn't use it anyways
        PCHL - Dunno how to assign to PCH and PCL
        IO/Special Groups - Not at that stage
        XTHL - useless
    ]#

# to do
proc readToMem(ourState: var state, filename: string, offset: uint16) =
    var data = filename.readFile
    copyMem addr ourState.mem[offset], addr data[0], data.len

proc renderTop(renderer: Renderer, curState: state) =
    var y = 0
    discard setRenderDrawColor(renderer, 255, 0, 0, 255)
    for i in 32..17:
        for bit in 7..0:
            var x = 0
            for j in 2400..2623:
                let index = i + (j*31)
                if (curState.mem[index] and (1 shl bit)) != 0:
                    discard renderDrawPoint(renderer, x, y)
            x += 1
        y += 1
    
    renderPresent(renderer)


proc renderBot(renderer: Renderer, curState: state) =
    var y = 128
    discard setRenderDrawColor(renderer, 255, 0, 0, 255)
    for i in 16..0:
        for bit in 7..0:
            var x = 0
            for j in 2400..2623:
                let index = i + (j*31)
                if (curState.mem[index] and (1 shl bit)) != 0:
                    discard renderDrawPoint(renderer, x, y)
            x += 1
        y += 1
    
    renderPresent(renderer)


proc render(renderer: Renderer, curState: state) =
    while true:
        discard setRenderDrawColor(renderer, 0, 0, 0, 0)
        discard renderClear(renderer)
        renderTop(renderer, curState)
        renderBot(renderer, curState)
# to do
proc main() =
    var done = 0
    var count = 0
    var ourState = state(a: 0, b: 0, c: 0, d: 0, e: 0, h: 0, l: 0, sp: 0xf000, pc: 0, intEnable: 0)
    ourState.mem = newSeq[byte](0x10000)

    readToMem(ourState, "rom/invaders.rom", 0)

    var event: Event
    var window: Window
    var renderer: Renderer
    discard init(INIT_VIDEO)
    discard createWindowAndRenderer(224*3, 256*3, 0, addr window, addr renderer)
    discard renderSetLogicalSize(renderer, 224, 256)
    discard setRenderDrawColor(renderer, 255, 0, 0, 255)
    renderPresent(renderer)

    while done == 0:
        if (pollEvent(addr event)) > 0:
            if event.kind == QUIT:
                break
        count += 1
        #if count == 500000:
           # spawn render(renderer, ourState)

        if count >= 500000 and count mod 1000 == 0:

            var currPc = ourState.pc
            done = emulate8080(ourState)
            if ourState.pc == currPc:
                ourState.pc += 1

    destroyRenderer(renderer)
    destroyWindow(window)
    sdl.quit()

main()