//===-- Falcon.td - Describe the Falcon Target Machine -----*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

include "llvm/Target/Target.td"

include "FalconRegisterInfo.td"
include "FalconCallingConv.td"
include "FalconInstrInfo.td"

// Features and processors
def FeatureFalcon034 : SubtargetFeature<"falcon034", "IsFalcon034", "true", "Falcon v0, v3, v4">;
def FeatureFalcon3p : SubtargetFeature<"falcon3p", "IsFalcon3p", "true", "Falcon v3+">;
def FeatureFalcon4p : SubtargetFeature<"falcon4p", "IsFalcon4p", "true", "Falcon v4+", [FeatureFalcon3p]>;
def FeatureFalcon5p : SubtargetFeature<"falcon5p", "IsFalcon5p", "true", "Falcon v5+", [FeatureFalcon4p]>;
def FeatureCrypt : SubtargetFeature<"crypt", "HasCrypt", "true", "Crypto coprocessor">;

def Falcon0 : SubtargetFeature<"falcon0", "FalconVersion", "0", "Falcon v0", [FeatureFalcon034]>;
def Falcon3 : SubtargetFeature<"falcon3", "FalconVersion", "3", "Falcon v3", [FeatureFalcon034, FeatureFalcon3p]>;
def Falcon4 : SubtargetFeature<"falcon4", "FalconVersion", "4", "Falcon v4", [FeatureFalcon034, FeatureFalcon4p]>;
def Falcon5 : SubtargetFeature<"falcon5", "FalconVersion", "5", "Falcon v5", [FeatureFalcon5p]>;

class Proc<string Name, list<SubtargetFeature> Features>
  : Processor<Name, NoItineraries, Features>;

def : Proc<"falcon0", [Falcon0]>;
def : Proc<"falcon3", [Falcon3]>;
def : Proc<"falcon4", [Falcon4]>;
def : Proc<"falcon5", [Falcon5]>;

def : Proc<"falcon0s", [Falcon0, FeatureCrypt]>;
def : Proc<"falcon3s", [Falcon3, FeatureCrypt]>;
def : Proc<"falcon4s", [Falcon4, FeatureCrypt]>;
def : Proc<"falcon5s", [Falcon5, FeatureCrypt]>;

def FalconInstrInfo : InstrInfo;

def Falcon : Target {
  let InstructionSet = FalconInstrInfo;
}
